require 'test_helper'

class ArticleTest < ActiveSupport::TestCase
  def setup
    @article = articles(:one)
  end
end