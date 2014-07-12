class AddNotestoreToEvernoteAccounts < ActiveRecord::Migration
  def change
    add_column :evernote_accounts, :notestore_url, :string
    add_column :evernote_accounts, :notebook_guid, :string
  end
end
