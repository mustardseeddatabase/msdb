class CreateTransactionItemsTable < ActiveRecord::Migration
  def change
    create_table :transaction_items do |t|
      t.string :type
      t.integer :transaction_id
      t.integer :item_id
      t.integer :quantity
      t.timestamps
    end
  end
end
