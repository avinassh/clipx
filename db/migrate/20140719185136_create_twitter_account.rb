class CreateTwitterAccount < ActiveRecord::Migration
  def change
    create_table :twitter_accounts do |t|
      
      # Numeric uid of the twitter account (Unique)
      t.integer :uid
      
      # Nickname of the user on twitter.
      t.string :username
      
      # Access token and secret
      t.string :token
      t.string :secret

      # ID and timestamp of the last read tweet
      t.integer :last_fetched_id
      t.integer :last_fetched, :default=>Time.now.to_i
      t.belongs_to :user
    end

    # Indexes
    add_index :twitter_accounts, :uid, unique: true
    add_index :twitter_accounts, :user_id # Index on the user_id field
  end
end
