FactoryGirl.define do
  factory :item do
    upc {rand(9999999999)}
    description { ["peanut butter",
                   "small red beans",
                   "Del monte Mandarin Oranges",
                   "tartar sauce",
                   "whole grain bread",
                   "eggs",
                   "Ovaltine",
                   "Seneca Mixed vegetables",
                   "CRYSTAL LIGHT",
                   "Pork & Beans"].sample }
    weight_oz 12
    category_id {1+rand(4)}
    count 1
    qoh {rand(10) + 1}
  end

  factory :item_with_barcode, :parent => :item do
    sku nil
    upc {rand(9999999999)}
  end

  factory :item_with_known_barcode, :parent => :item do
    sku nil
    upc 12341234
  end

  factory :item_with_sku, :parent => :item do
    upc nil
    sku {rand(999)}
  end
end
