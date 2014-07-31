class Article < ActiveRecord::Base
  validates_presence_of :url, :provider, :status, :user_id
  validates_uniqueness_of :url, :scope => [:user_id, :url]
  belongs_to :user

  def title_or_heading
    return title unless !title or title.squish.empty?
    return heading unless !heading or heading.squish.empty?
    "Empty Title"
  end
end