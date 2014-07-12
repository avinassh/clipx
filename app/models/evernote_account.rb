class EvernoteAccount < ActiveRecord::Base
  belongs_to :user
  validates_presence_of :username, :token, :user_id, :notestore_url, :notebook_guid
end