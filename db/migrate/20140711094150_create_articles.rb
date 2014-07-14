class CreateArticles < ActiveRecord::Migration
  def change
    create_table :articles do |t|
      # Link of the article
      t.string :url
      # Title provided by the provider service
      t.string :title
      # Heading is generated by the extractor job
      # This is actual article heading retrieved from the webpage
      # and may differ from the title
      t.string :heading
      # Content in HTML (again, generated by extractor)
      t.string :content
      # Single representative image of the article
      t.string :image
      # Tags in CSV format
      t.string :tags
      # Lowercase string representation of the provider that generated this article
      t.string :provider
      # Status can hold the following values
      # - fetched (Means article URL and some metadata was fetched)
      # - held (Content has been filled in by readability)
      # - pushed(Pushed to all of the connecting services)
      t.string :status, :default => 'fetched'  # Current status of the article
      t.timestamps
      t.belongs_to :user
    end
  end
end
