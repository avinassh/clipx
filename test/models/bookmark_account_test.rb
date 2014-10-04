require 'test_helper'

class BookmarkAccountTest < ActiveSupport::TestCase
  def setup
    @bookmark = BookmarkAccount.new
  end
  test "should generate a new token on creation" do
    assert_not_nil @bookmark.token
  end

  test 'should regenerate token' do
    original_token = @bookmark.token
    @bookmark.setup_token
    assert_not_nil @bookmark.token
    assert_not_equal @bookmark.token, original_token
    puts @bookmark.token
  end
end
