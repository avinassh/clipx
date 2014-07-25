class ChangeLastFetchedIdToString < ActiveRecord::Migration
  def change
    change_column :twitter_accounts, :last_fetched_id, :string, :limit => 255
  end
end
