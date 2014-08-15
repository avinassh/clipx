require 'test_helper'

class ArticleTest < ActiveSupport::TestCase
  def setup
    @article = articles(:one)
  end

  test 'title_or_heading' do
    assert_equal @article.title, @article.title_or_heading
    @article.title = "  "
    assert_equal @article.heading, @article.title_or_heading
    @article.heading = "  "
    assert_equal "Empty Title", @article.title_or_heading
  end

  test 'title or heading with nils' do
    @article.title= nil
    @article.heading = nil
    assert_equal "Empty Title", @article.title_or_heading

    @article.heading = "Heading"
    assert_equal "Heading", @article.title_or_heading
  end

  test 'autocomplete should work' do
    Article.all.reindex
    res = Article.autocomplete("Sample", @article.user_id)
    assert_equal 1, res.count
    assert_equal ["Sample Title"], res
  end
end