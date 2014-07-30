require 'test_helper'
require 'mocha'

class GoogleAccountTest < ActiveSupport::TestCase
  def setup
    @account = evernote_accounts(:default)
  end

  test 'should create a new account' do
    assert_difference('GoogleAccount.count') do
      # Stub the spreadsheet creation, so we don't hit the API
      Google.any_instance.stubs(:fetch_notebook).returns(@account.notebook_guid)
      # create the account
      account = EvernoteAccount.create_from_omniauth self.omniauth.evernote
      # We do this so that the user_id field validates
      account.user_id = 5
      account.username = 'captn3m0'
      #Try to save it and raise an error if it fails
      account.save!
    end
  end

  test 'should return its publishing service' do
    publisher = @account.publisher
    assert publisher.is_a? PublisherService
  end
end