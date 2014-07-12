class Article < ActiveRecord::Base
  validates_presence_of :url, :provider, :status, :user_id
  belongs_to :user
end
