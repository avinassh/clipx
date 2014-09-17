class CreatePublishStatuses < ActiveRecord::Migration
  def change
    create_table :publish_statuses do |t|
      t.references :article, index: true
      t.string :provider

      t.timestamps
    end
  end
end
