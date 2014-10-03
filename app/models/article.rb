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
      user_id: user_id,
      created_at: created_at
    }
  end

  validates_presence_of :url, :provider, :status, :user_id
  validates_uniqueness_of :url, :scope => [:user_id, :url]
  belongs_to :user
  has_many :publish_statuses

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

  # Marks the article as published with the given provider
  def mark_as_published(provider)

    self.update_attribute("status", "published") if self.status!= "published"
    status = self.publish_statuses.find_by_provider(provider)

    if status.nil?
      # We need to create a new status
      self.publish_statuses.create({provider: provider})
    else
      # Update the timestamp to reflect that it was republished
      status.touch
    end
  end

  # Checks whether the article has been published to the given provider
  # Returns status or nil to report the article's publication status
  def published?(provider)
    self.publish_statuses.find_by_provider(provider)
  end
end
