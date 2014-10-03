require 'test_helper'

class ArticleTest < ActiveSupport::TestCase
  def setup
    @article = articles(:one)
    @github_article = articles(:github)
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

  test 'article should be publishable' do
    @github_article.mark_as_published("evernote")
    assert_equal 1, @github_article.publish_statuses.length
  end

  test 'repeated calls to mark_as_published should not create new rows in db' do
    @github_article.mark_as_published("evernote")
    @github_article.mark_as_published("evernote")
    assert_equal 1, @github_article.publish_statuses.length
  end

  test 'should be publishable with a second provider' do
    @github_article.mark_as_published("evernote")
    @github_article.mark_as_published("dropbox")
    # We sort it because the statuses can be returned in any order (fixtures are not ordered)
    statuses = @github_article.publish_statuses.map(&:provider).sort
    assert_equal 2, statuses.length
    assert_equal "dropbox", statuses.first
    assert_equal "evernote",  statuses.second
  end

  test 'published? should work' do
    assert @article.published? 'evernote'
    assert @article.published? 'dropbox'
    assert_nil @article.published? 'google'
  end


  test "mark_as_published should set the article's status field as well" do
    # Make sure that the status was fetched to confirm the change
    @github_article.update_attribute 'status', 'fetched'
    @github_article.mark_as_published('evernote')
    assert_equal @github_article.status, 'published'
  end

end