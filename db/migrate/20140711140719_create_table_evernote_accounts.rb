class CreateTableEvernoteAccounts < ActiveRecord::Migration
  def change
    create_table :evernote_accounts do |t|
      t.string :token
      t.integer :last_published
      t.string :username  #This is the user's evernote username
      t.belongs_to :user
    end
    #So we can search by the evernote username, and also disable people from connecting same pocket account twice
    add_index :evernote_accounts, :username, unique: true
    add_index :evernote_accounts, :user_id #Index on the user_id field
  end
end
