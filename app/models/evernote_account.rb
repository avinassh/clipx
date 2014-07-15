class EvernoteAccount < PublisherAccount
  validates_presence_of :username, :token, :notestore_url, :notebook_guid
end