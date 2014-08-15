require 'test_helper'

class GooglePublisherTest < ActiveSupport::TestCase
  def setup
    @account = google_accounts(:second)
  end

  test 'export should work' do
    service = GooglePublisher.new
    service.export(@account)
  end
end