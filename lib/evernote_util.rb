require 'evernote-thrift'
require 'loofah'
require 'xml'
class EvernoteUtil < Evernote::EDAM::NoteStore::NoteStore::Client
  @@scrubber = EvernoteScrubber.new
  @@dtd = XML::Dtd.new File.read Rails.root.join('public', 'dtd','enml2.dtd')
  def self.textToENML(text)
    # TODO: Convert to heredoc
    body  = "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n"
    body += "<!DOCTYPE en-note SYSTEM \"http://xml.evernote.com/pub/enml2.dtd\">\n"
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

  # title - plain text
  # content - text or html (will be converted to enml)
  # notebook_guid - valid guid of the notebook in which to add this tag
  # tags - an array of tag names (String) that must be added to this tag
  def create_note(title, content, notebook_guid, tags, url, source = nil)
    note = Evernote::EDAM::Type::Note.new
    note.title = title
    note.tagNames = tags.split(',')
    note.content = self.class.HtmlToENML content
    note.tagNames = tags.map &:squish # Tag names may not begin or end with a space. 
    note.notebookGuid = notebook_guid if notebook_guid
    note.attributes = self.create_note_attribute url, source
    raise 'ENML Validation failed' unless self.class.validate_enml note.content
    
    begin
      self.createNote @token, note
    rescue Evernote::EDAM::Error::EDAMUserException => e
      # Because the EDAMUserException has no proper message
      raise "Invalid ENML: #{e.parameter}"
      puts e.to_json
    end
  end

  # TODO: Add author info here as well
  # Creates an attributes object for use with note creation
  # Also adds a source and source app, so user can see which app created this
  def create_note_attribute(url, source)
    attribute = Evernote::EDAM::Type::NoteAttributes.new
    attribute.sourceURL = url
    attribute.source = source ? "ClipX - via #{source}" : 'ClipX'
    attribute.sourceApplication = 'ClipX'
    attribute
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
  
  def self.fix_tags(html)
    require 'tidy_ffi'
    tidy = TidyFFI::Tidy.new(html)
    tidy.options.output_xhtml = true
    tidy.options.char_encoding = 'utf8'
    tidy.options.output_encoding = 'utf8'
    tidy.options.indent = 1
    tidy.options.show_warnings = true
    tidy.options.new_blocklevel_tags = 'article, heading'
    doc = tidy.clean
    if doc.nil?
      puts tidy.errors
      raise 'Invalid HTML'
    end
    # We force encode coz the above tidy options don't seem to work
    doc.force_encoding('UTF-8')
    # tidy.clean returns html with doctype and everything
    # So we pick the body tag's inner html
    return doc[(doc.index("<body>")+6)..(doc.index("</body>")-1)]
  end
  # Convert an html partial to enml format
  # validates the doc offline and throws errors
  def self.HtmlToENML(html)    
    # The order of  calls is important
    # All methods return strings, not xml entities
    # sanitize returns valid xhtml enml, which must be wrapped inside en-note
    # to work
    self.textToENML self.fix_tags self.sanitize html
  end

  # Takes in invalid enml and
  # Removes all unsafe attributes/tags
  def self.sanitize(enml)
    Loofah.fragment(enml).scrub!(@@scrubber).to_s
  end


  def self.validate_enml(enml)
    enml_document = XML::Document.string enml
    enml_document.validate @@dtd
  end

end