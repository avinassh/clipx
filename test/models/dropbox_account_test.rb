require 'test_helper'

class DropboxAccountTest < ActiveSupport::TestCase
  def setup
    @first = dropbox_accounts(:default)
  end

  test 'should create a new account' do
    assert_difference('DropboxAccount.count') do
      dropbox_account = DropboxAccount.create_from_omniauth self.omniauth.dropbox
      # We do this so that the user_id field validates
      dropbox_account.user = @first.user
      dropbox_account.save!
    end
  end
end