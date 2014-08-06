require 'test_helper'

class ImportJobTest < ActiveSupport::TestCase
  def setup
    @user = users(:default)
    @pocket = pocket_accounts(:default)
  end

  test 'pocket import' do
    articles = ImportJob.pocket(@pocket)
    assert_not_nil articles
    assert articles.length > 0
  end

  test 'pocket via perform' do
    ImportJob.perform(@pocket.user.id, "PocketAccount", @pocket.id)
  end
end