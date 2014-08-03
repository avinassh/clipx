class CreateDropboxAccounts < ActiveRecord::Migration
  def change
    create_table :dropbox_accounts do |t|
      t.string :email
      t.string :uid
      t.string :token
      t.belongs_to :user
    end
    add_index :dropbox_accounts, :uid, unique: true
    add_index :dropbox_accounts, :user_id # Index on the user_id field
  end
end
