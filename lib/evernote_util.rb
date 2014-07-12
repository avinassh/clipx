require 'evernote-thrift'

class EvernoteUtil < Evernote::EDAM::NoteStore::NoteStore::Client
  def self.textToENML(text)
    body = "<?xml version=\"1.0\" encoding=\"UTF-8\"?>"
    body += "<!DOCTYPE en-note SYSTEM \"http://xml.evernote.com/pub/enml2.dtd\">"
    body += "<en-note>#{text}</en-note>"
    return body
  end

  # search for a notebook with a given name
  # Returns a notebook object
  def find_notebook(name)
    notebooks = self.listNotebooks(@token)
    notebooks.each do |notebook|
      return notebook if notebook.name.eql? name
    end
    return nil
  end

  def find_or_create_notebook(name)
    search_result = find_notebook name
    return search_result if search_result
    create_notebook name
  end

  # Creates a new notebook
  # Returns the notebook object, not just the guid
  def create_notebook(name)
    # Taken from http://stackoverflow.com/questions/5631055/not-able-to-create-notebook-and-transfer-files-in-evernote
    notebook = Evernote::EDAM::Type::Notebook.new()
    notebook.name = name
    self.createNotebook @token, notebook
  end

  def create_note(title, content, notebook_guid)
    note = Evernote::EDAM::Type::Note.new
    note.title = title
    note.content = self.class.textToENML content
    note.notebookGuid = notebook_guid if notebook_guid
    self.createNote @token, note
  end

  def initialize(notestore_url, token)
    # Evernote API rubbish
    noteStoreTransport = Thrift::HTTPClientTransport.new notestore_url
    noteStoreProtocol = Thrift::BinaryProtocol.new noteStoreTransport

    # Save the token with the notestore so we can re-use it without passing it around
    @token = token

    # Call the parent constructor with just the protocol
    super noteStoreProtocol
  end
  def token
    puts @token
  end
end