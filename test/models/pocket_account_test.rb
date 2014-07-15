require 'test_helper'

class PocketAccountTest < ActiveSupport::TestCase
  def setup
    @first = pocket_accounts(:default)
  end

  test 'should create a new account' do
    assert_difference('PocketAccount.count') do
      pocket_account = PocketAccount.create_from_omniauth self.omniauth.pocket
      # We do this so that the user_id field validates
      pocket_account.user = @first.user
      pocket_account.save!
    end
  end
end