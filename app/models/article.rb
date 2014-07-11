class Article < ActiveRecord::Base
  validates_presence_of :url, :provider
  belongs_to :user
end
