require 'test_helper'

class PublishStatusTest < ActiveSupport::TestCase
  def setup
    @status1 = publish_statuses :evernote
    @article_one = articles(:one)
    @article_two = articles(:two)
  end

  test 'publish status should be available' do
    assert_not_nil @status1
  end

  test 'publish status should belong to a article' do
    assert_not_nil @status1.article
  end

  test 'the article should know its publish status' do
    assert_not_nil @status1.article.publish_statuses
  end

  test 'first article should have two publish_statuses' do
    assert_equal(2, @article_one.publish_statuses.size)
  end
end