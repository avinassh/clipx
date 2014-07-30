require 'test_helper'

class TwitterAccountTest < ActiveSupport::TestCase
  def setup
    @first = twitter_accounts(:default)
  end

  test 'should create a new account' do
    assert_difference('TwitterAccount.count') do
      twitter_account = TwitterAccount.create_from_omniauth self.omniauth.twitter
      # We do this so that the user_id field validates
      twitter_account.user = @first.user
      twitter_account.save!
    end
  end
end