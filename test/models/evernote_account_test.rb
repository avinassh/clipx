require 'test_helper'
require 'mocha'
require 'ostruct'
class EvernoteAccountTest < ActiveSupport::TestCase
  def setup
    @account = evernote_accounts(:default)
  end

  test 'should create a new account' do
    assert_difference('EvernoteAccount.count') do
      # Stub the notebook creation, so we don't hit the API
      EvernoteUtil.any_instance.stubs(:find_or_create_notebook).returns(OpenStruct.new(:guid=>@account.notebook_guid))
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