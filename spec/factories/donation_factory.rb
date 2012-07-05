FactoryGirl.define do
  factory :donation do
    donor
    after(:create) do | donation |
      FactoryGirl.create_list(:donated_item, 3, :donation => donation)
    end

    trait :with_known_barcode do
      after(:create) do | donation |
        FactoryGirl.create(:donated_item, :with_known_barcode, :donation => donation)
      end
    end
  end
end

FactoryGirl.define do
  factory :donated_item do
    quantity { rand(1..4) }
    association :item, :factory => [:item, :with_barcode]

    trait :with_known_barcode do
      association :item, :factory => [:item, :with_known_barcode]
    end
  end
end
