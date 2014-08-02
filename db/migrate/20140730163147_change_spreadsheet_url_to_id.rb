class ChangeSpreadsheetUrlToId < ActiveRecord::Migration
  def change
    rename_column :google_accounts, :spreadsheet_url, :spreadsheet_id
  end
end
