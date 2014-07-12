class CreatePocketTable < ActiveRecord::Migration
  def change
    create_table :pocket_accounts do |t|
      t.string :token
      t.integer :last_fetched
      t.string :username  #This is the user's pocket username
      t.belongs_to :user
      # TODO: Create a migration  for optional filter tag to add to pocket
    end
    remove_column :users, :pocket # This was earlier used for saving the pocket token
    # So we can search by the pocket username, and also disable people from connecting same pocket account twice
    add_index :pocket_accounts, :username, unique: true
    add_index :pocket_accounts, :user_id # Index on the user_id field
  end
end