require 'test_helper'

class ExtractorJobTest < ActiveSupport::TestCase
  def setup
    @extractor = ExtractorJob.new
    @article = articles(:github)
  end

  test 'github' do
    assert_equal @article.provider, 'github'
    webpage = @extractor.github @article
    assert_equal @article.heading, webpage.title
    assert_not_nil webpage.content
  end
end