class Article < ActiveRecord::Base
  # For searching, obvi
  searchkick

  def search_data
    {
      title: title,
      heading: heading,
      provider: provider,
      status: status,
      tags: tags,
      user_id: user_id
    }
  end

  validates_presence_of :url, :provider, :status, :user_id
  validates_uniqueness_of :url, :scope => [:user_id, :url]
  belongs_to :user

  # Extracted scope gives us articles that have had their content fetched
  scope :extracted, -> { where(status: ['published','held']) }

  def title_or_heading
    return title unless !title or title.squish.empty?
    return heading unless !heading or heading.squish.empty?
    "Empty Title"
  end

  def self.autocomplete(query, user_id)
    Article.search(query, fields: ["title", "heading"], where: {user_id: user_id}).map(&:title_or_heading)
  end

end