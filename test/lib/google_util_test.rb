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

  test 'should find or create spreadsheet' do
    client = GoogleUtil.new @second
    title = (0...8).map { (65 + rand(26)).chr }.join
    # This should be creating
    doc = client.find_or_create_spreadsheet title
    assert_equal doc['title'], title

    # Now we should be finding it
    doc = client.find_or_create_spreadsheet title
    assert_equal doc['title'], title

    # And now we delete it
    client.delete_spreadsheet doc['id']
  end
end