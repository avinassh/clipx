require 'test_helper'
require 'mocha'

class GoogleAccountTest < ActiveSupport::TestCase
  def setup
    @account = google_accounts(:default)
  end

  test 'should create a new account' do
    assert_difference('GoogleAccount.count') do
      # Stub the spreadsheet creation, so we don't hit the API
      GoogleAccount.any_instance.stubs(:fetch_spreadsheet).returns(@account.spreadsheet_id)
      # create the account
      account = GoogleAccount.create_from_omniauth self.omniauth.google
      # We do this so that the user_id and email field validate
      account.user_id = 3
      account.email = 'nemo@clipx.io'
      #Try to save it and raise an error if it fails
      account.save!
    end
  end

  test 'should return its publishing service' do
    publisher = @account.publisher
    assert publisher.is_a? PublisherService
  end
end