class DistributionItem < TransactionItem
  belongs_to :distribution, :foreign_key => :transaction_id
end
