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
end