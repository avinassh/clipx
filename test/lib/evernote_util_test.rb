require 'test_helper'

class EvernoteUtilTest < ActiveSupport::TestCase

  def setup
    # Load the fixture
    @account = evernote_accounts :default
    # Create an evernote lib client
    @client = EvernoteUtil.new @account.notestore_url, @account.token
  end

  test 'library autoloaded' do
    assert_instance_of EvernoteUtil, @client, "EvernoteUtil object creation failed"
  end

  test 'find_unknown_notebook' do
    notebook = @client.find_notebook "Abracadabra"
    assert_nil notebook
  end

  test 'find_notebook' do
    name = 'First Notebook'
    notebook = @client.find_notebook name
    assert_not_nil notebook, "find notebook failed"
    assert_equal name, notebook.name, "Incorrect notebook returned"
  end

  # This testcase is commented out because evernote has a limit of 250 notebooks
  # And the expungeNotebook method is not available to third-party apps
  # so we can't delete any notebooks that we create with the API automatically
  # hence, we avoid creating any new notebooks unless absolutely needed
=begin
  test 'create_new_notebook' do
    name = (0...8).map { (65 + rand(26)).chr }.join
    notebook = @client.create_notebook name
    assert_equal name, notebook.name, "Notebook name doesn't match"
  end
=end

  test 'recreate existing_notebook' do
    #This is the default notebook in evernote
    name = 'First Notebook'

    # Expect a UserException to be raised
    e = assert_raises(Evernote::EDAM::Error::EDAMUserException) { @client.create_notebook name }

    # ErrorCode 10 is for data conflict, which means we are trying to re-create an existing notebook
    assert_equal e.errorCode, 10, "Incorrect errorCode"
    assert_equal e.parameter, "Notebook.name", "Exception raised in incorrect parameter (name expected)"
  end


  test 'find_or_create_notebook' do
    name = 'ClipX'
    notebook = @client.find_or_create_notebook name
    assert_equal name, notebook.name, 'Incorrect notebook returned'
  end

  test 'validate html entities' do
    assert EvernoteUtil.validate_enml EvernoteUtil.textToENML '&nbsp;'
    assert_not EvernoteUtil.validate_enml EvernoteUtil.textToENML '&hello;'
  end

  test 'fix_tags should be working' do
    original = "<br>"
    assert_equal "<br />", EvernoteUtil.fix_tags(original).squish
  end
end