require 'securerandom'

class BookmarkAccount < AbstractAccount
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
