FactoryGirl.define do
  factory :donation do
    donor
    after_create do | donation |
      FactoryGirl.create_list(:donated_item, 3, :transaction_id => donation.id)
    end
  end

  factory :donation_with_known_barcode, :parent => :donation do
    donor
    after_create do | donation |
      FactoryGirl.create(:donated_item_with_known_barcode, :transaction_id => donation.id)
    end
  end
end

FactoryGirl.define do
  factory :donated_item do
    quantity { rand(4).to_i + 1 }
    item :factory => :item_with_barcode
  end

  factory :donated_item_with_known_barcode, :parent => :donated_item do
    quantity { rand(4).to_i + 1 }
    item :factory => :item_with_known_barcode
  end
end
