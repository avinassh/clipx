class CreateArticles < ActiveRecord::Migration
  def change
    create_table :articles do |t|
      t.string :url  #Link of the article
      t.string :title#Title provided by the provider service
      t.string :heading#Heading is generated by readabililty
      t.string :content#Content in HTML
      t.string :image  #Single representative image of the article
      t.string :tags    #Tags in CSV format
      t.string :provider#String representation of the provider that generated this article
      #Status can hold the following values
      #- fetched (Means article URL and some metadata was fetched)
      #- held (Content has been filled in by readability)
      #- pushed(Pushed to all of the connecting services)
      t.string :status, :default => 'fetched'  #Current status of the article
      t.timestamps
      t.belongs_to :user
    end
  end
end
