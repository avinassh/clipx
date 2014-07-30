require 'test_helper'

class GoogleUtilTest < ActiveSupport::TestCase
  def setup
    @account = google_accounts(:default)
    @second = google_accounts(:second)
  end

  test 'should initialize with working token' do
    client = GoogleUtil.new @account
    assert_instance_of GoogleDrive::Session, client.gdrive, "Invalid GoogleDrive client"
    assert_instance_of SimpleGoogleDrive::Client, client.simple_client, "Invalid SimpleGoogleDrive client"
  end

  test 'should initialize with refresh token' do
    client = GoogleUtil.new @second
    assert_instance_of GoogleDrive::Session, client.gdrive, "Invalid GoogleDrive client"
    assert_instance_of SimpleGoogleDrive::Client, client.simple_client, "Invalid SimpleGoogleDrive client"
  end

  test 'should create spreadsheet'  do
    # We use @second because it is guaranteed to give us a working token using refresh
    client = GoogleUtil.new @second
    doc = client.create_spreadsheet 'ClipX Test', 'Sample ClipX spreadsheet'
    assert_not_nil doc
    # Delete the stray empty spreadsheet as well
    client.delete_spreadsheet(doc['id'])
  end

end