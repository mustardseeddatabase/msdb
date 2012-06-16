namespace :ccstb do
  desc 'move distribution_items and donated_items into transaction_items'
  task :populate_transaction_items => :environment do
    # note this only works before DonatedItem and DistributionItem
    # have been subclassed to TransactionItem!
    total = DonatedItem.count
    i = 0
    DonatedItem.all.each do |donated_item|
      ti = TransactionItem.create(
        :transaction_id => donated_item.donation_id,
        :item_id => donated_item.item_id,
        :quantity => donated_item.quantity)
      ti.update_attribute(:type, 'DonatedItem')
      i += 1
      percent = (i.to_f*100/total).to_i
      print "\rDonated item #{i}, #{percent}%"
    end
    print "\n\r"
    total = DistributionItem.count
    i = 0
    DistributionItem.all.each do |distribution_item|
      ti = TransactionItem.create(
        :transaction_id => distribution_item.distribution_id,
        :item_id => distribution_item.item_id,
        :quantity => distribution_item.quantity)
      ti.update_attribute(:type, 'DistributionItem')
      i += 1
      percent = (i.to_f*100/total).to_i
      print "\rDistribution item #{i}, #{percent}%"
    end
    print "\n\r"
  end
end
