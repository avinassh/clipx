require 'test_helper'

class GithubAccountTest < ActiveSupport::TestCase
  def setup
    @first = github_accounts(:default)
  end

  test 'should create a new account' do
    assert_difference('GithubAccount.count') do
      github_account = GithubAccount.create_from_omniauth self.omniauth.github
      # We do this so that the user_id field validates
      github_account.user = @first.user
      github_account.save!
    end
  end
end