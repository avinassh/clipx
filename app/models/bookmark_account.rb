require 'securerandom'

class BookmarkAccount < AbstractAccount
  cattr_accessor :fetcher_name
  @@fetcher_name = 'Bookmarks'
  validates_presence_of :token
  belongs_to :user
  attr_reader :token

  # Creates a new BookmarkAccount
  # associated with a user
  def initialize
    setup_token
  end

  # Generates a new token
  # returns the random token
  def setup_token
    token = SecureRandom.hex(16)
    @token = token
    token
  end
end
