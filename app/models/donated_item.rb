class DonatedItem < TransactionItem
  belongs_to :donation, :foreign_key => :transaction_id
end
