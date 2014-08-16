require 'test_helper'

class UserTest < ActiveSupport::TestCase
  def setup
    @user = users(:default)
    @second_user = users(:non_admin)
  end

  test 'should return accounts' do
    assert @user.accounts.length > 0, "Number of connected accounts found: #{@user.accounts}"
    @user.accounts.each do |account|
      assert account.class < AbstractAccount, "Account does not inherit from AbstractAccount"
    end
  end

  test 'should return publisher accounts' do
    assert @user.accounts.each do |publisher|
      assert publisher.class < PublisherAccount
    end
  end

  test 'admin? should work' do
    assert @user.admin?
    assert_not users(:non_admin).admin?
  end

  test 'should add test account' do
    # Make sure the user didn't have a pocket integration already
    assert_nil @second_user.pocket_account
    account = @second_user.add_account 'pocket', self.omniauth.pocket
    assert_equal account.user, @second_user
    assert_equal @second_user.pocket_account, account
  end

  test 'should remove account before attaching a new one' do
    # Make sure the user didn't have a pocket integration already
    assert @user.pocket_account
    account = @user.add_account 'pocket', self.omniauth.pocket
    assert_equal account.user, @user
    assert_equal @user.pocket_account, account
  end

  test 'should return fetcher names' do
    assert @user.fetcher_names.include? "Pocket"
    assert @user.fetcher_names.include? "GitHub"
    assert @user.fetcher_names.include? "Twitter"
    assert_not @user.fetcher_names.include? "Evernote"
  end
end
