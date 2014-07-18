class ChangeStringToTextForArticle < ActiveRecord::Migration
  def change
    change_column :articles, :url, :text, :limit => nil
    change_column :articles, :title, :text, :limit => nil
    change_column :articles, :heading, :text, :limit => nil
    change_column :articles, :content, :text, :limit => nil
    change_column :articles, :image, :text, :limit => nil
    change_column :articles, :tags, :text, :limit => nil
  end
end
