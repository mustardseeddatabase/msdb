class DistributionItem < TransactionItem
  belongs_to :distribution, :foreign_key => :transaction_id

  def weight_lb
    ((quantity * item.weight_oz).to_f/16).round(2)
  end
end
