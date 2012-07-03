class AddIndexToTransactions < ActiveRecord::Migration
  def change
    add_index 'transaction_items', 'transaction_id'
  end
end
