FactoryGirl.define do
  factory :distribution_item do
    item_id {rand(50)}
    transaction_id {rand(50)}
  end
end
