class CreateGithubAccount < ActiveRecord::Migration
  def change
    create_table :github_accounts do |t|
      # Numeric uid of the github account (Unique)
      t.integer :uid

      # Nickname of the user on twittergithub
      t.string :username

      # Access token
      t.string :token

      # Last fetched timestamp
      t.integer :last_fetched

      t.belongs_to :user

    end

    # Indexes
    add_index :github_accounts, :uid, unique: true
    add_index :github_accounts, :user_id # Index on the user_id field
  end
end
