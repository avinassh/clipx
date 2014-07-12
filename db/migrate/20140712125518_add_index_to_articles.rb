class AddIndexToArticles < ActiveRecord::Migration
  def change
  	add_index :articles, [:url, :user_id], :unique => true
  end
end
