class CreateGoogleAccount < ActiveRecord::Migration
  def up
    create_table :google_accounts do |t|
      t.string :email
      t.string :refresh_token
      t.string :token
      t.integer :last_published, :default=>Time.now.to_i
      # Unix timestamp of when our token will expire
      t.integer :token_expiry
      t.string :spreadsheet_url, :limit =>500
      t.belongs_to :user
    end
  end
  def down
    drop_table :google_accounts
  end
end
