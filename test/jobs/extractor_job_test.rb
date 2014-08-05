require 'test_helper'

class ExtractorJobTest < ActiveSupport::TestCase
  def setup
    @article = articles(:github)
  end

  test 'github' do
    assert_equal @article.provider, 'github'
    webpage = ExtractorJob.github @article
    assert_equal @article.heading, webpage.title
    assert_not_nil webpage.content
  end

  test 'github using perform' do
    ExtractorJob.perform @article.id
  end
end