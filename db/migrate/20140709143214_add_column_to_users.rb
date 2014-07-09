class AddColumnToUsers < ActiveRecord::Migration
  def change
    add_column :users, :pocket, :string
  end
end
