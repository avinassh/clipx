class Article < ActiveRecord::Base
  validates_presence_of :url, :provider, :status, :user_id
  validates_uniqueness_of :url, :scope => [:user_id, :url]
  belongs_to :user
end