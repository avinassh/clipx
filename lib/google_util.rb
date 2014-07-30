require 'google_drive'
require 'simple_google_drive'

class GoogleUtil
  # Initializes a new google drive util instance
  # account - A GoogleAccount instance
  def initialize(account)
    @account = account
    setup_session
  end

  # Makes sure that the token we are using is active
  def setup_session
    # We need to refresh our token if expiry time is in the past
    if @account.token_expiry < Time.now.to_i
      update_token
    end
    # Now we login with this token
    @simple_client = SimpleGoogleDrive.new(@account.token)
    @gdrive = GoogleDrive.login_with_oauth(@account.token)
  end

  # Updates the current token
  # using the refresh token
  def update_token
    client = OAuth2::Client.new(
      # We re-use the values from
      Rails.application.secrets.google_key,
      Rails.application.secrets.google_secret,
      :site => Devise.omniauth_configs[:google].strategy_class.default_options.client_options.site,
      :token_url => Devise.omniauth_configs[:google].strategy_class.default_options.client_options.token_url,
      :authorize_url => Devise.omniauth_configs[:google].strategy_class.default_options.client_options.authorize_url
    )
    auth_token = OAuth2::AccessToken.from_hash(
      client,
      {
        :refresh_token => @account.refresh_token,
        :expires_at => @account.token_expiry
      }
    ).refresh!
    @account.update_attribute 'token_expiry', auth_token.expires_at
    @account.update_attribute 'token', auth_token.token
  end

  # Creates a new spreadsheet with given title
  # Returns spreadsheet instance
  def create_spreadsheet(title, description)
    body = {
      :title => title,
      :description => description,
      :mimeType => 'application/vnd.google-apps.spreadsheet'
    }
    @simple_client.files_insert(body)
  end

  def delete_spreadsheet(id)
    @simple_client.files_delete(id)
  end
  # Finds or creates a new spreadsheet
  # Returns spreadsheet instance
  def find_or_create_spreadsheet(title)
    spreadsheet = @session.spreadsheet_by_title(title)
    return spreadsheet if spreadsheet
    self.create_spreadsheet(title)
  end
  private :setup_session, :update_token
  attr_reader :gdrive, :simple_client
end