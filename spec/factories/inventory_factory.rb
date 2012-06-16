FactoryGirl.define do
  factory :inventory do
    after(:create) do | inventory |
      FactoryGirl.create_list(:inventory_item, 3, :transaction_id => inventory.id)
    end
  end

  factory :inventory_item do
    item :factory => :item
    quantity 1
  end
end
