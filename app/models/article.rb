class Article < ActiveRecord::Base
  # For searching, obvi
  searchkick

  validates_presence_of :url, :provider, :status, :user_id
  validates_uniqueness_of :url, :scope => [:user_id, :url]
  belongs_to :user

  # Extracted scope gives us articles that have had their content fetched
  scope :extracted, -> { where(status: ['published','held']) }

  def title_or_heading
    return title unless title.squish.empty?
    return heading unless heading.squish.empty?
    "Empty Title"
  end
end