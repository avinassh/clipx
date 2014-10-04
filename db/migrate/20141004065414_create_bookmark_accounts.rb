class CreateBookmarkAccounts < ActiveRecord::Migration
  def change
    create_table :bookmark_accounts do |t|
      t.string :token
      t.belongs_to :user
      t.integer :last_fetched, :default=>Time.now.to_i
      t.timestamps
    end
  end
end
