class InventoryItem < TransactionItem
  belongs_to :inventory, :foreign_key => :transaction_id
end
