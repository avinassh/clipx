class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable, :omniauth_providers => [:pocket, :evernote, :twitter, :github, :google, :dropbox]
  has_one :pocket_account, :dependent => :destroy
  has_one :github_account, :dependent => :destroy
  has_one :evernote_account, :dependent => :destroy
  has_one :twitter_account, :dependent => :destroy
  has_one :google_account, :dependent => :destroy
  has_one :dropbox_account, :dependent => :destroy
  has_many :articles, :dependent => :destroy
  has_one :bookmark_account, :dependent => :destroy

  def add_account_omniauth(provider, omniauth)
    # The user model should not be concerned about parsing the omniauth hash
    # which can vary for different accounts
    account_class = (provider + '_account').camelize.constantize
    account = account_class.create_from_omniauth omniauth

    # ActiveRecord automatically adds these methods
    # for every association, which we are calling
    # note that assignment is part of the method name
    # this is equivalent to eval ("self.#{provider}_account = account")
    assignment_symbol = (provider + '_account=').to_sym
    self.send assignment_symbol, account

    # Return a copy of the just created account as well
    account
  end

  def admin?
    self.email == Rails.application.secrets.admin_email
  end

  # Returns all integrated accounts available to the user
  # type - Class to filter this account list against
  #        You may so far pass only PublisherAccount to this option
  def accounts(type=AbstractAccount)
    # See http://stackoverflow.com/questions/3371518/in-ruby-is-there-an-array-method-that-combines-select-and-map/17703276#17703276
    # for why reduce was used here
    self.class.reflect_on_all_associations(:has_one).reduce([]) do |result, association|
      result.push self.send association.name if association.klass < type
      result
    end
  end

  def fetcher_names
    result = []
    self.class.reflect_on_all_associations(:has_one).reduce([]) do |key, association|
      unless association.klass <  PublisherAccount
        result.push association.klass.fetcher_name
      end
    end
    result
  end

  # Returns all PublisherAccounts belonging to the user
  def publishers
    self.accounts PublisherAccount
  end
end
