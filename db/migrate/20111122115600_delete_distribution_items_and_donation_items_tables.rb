class DeleteDistributionItemsAndDonationItemsTables < ActiveRecord::Migration
  def change
    drop_table :distribution_items
    drop_table :donated_items
  end
end
