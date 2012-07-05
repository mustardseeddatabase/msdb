require 'faker'

FactoryGirl.define do
  factory :address do
    address  { Faker::Address.street_address }
    city  { Faker::Address.city }
    zip  { Faker::Address.zip_code }
    apt  { rand(400) }

    factory :temp_address, :class => TempAddress

    factory :perm_address, :class => PermAddress
  end
end
