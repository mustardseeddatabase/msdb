require 'faker'

FactoryGirl.define do
  factory :address do
    address  { Faker::Address.street_address }
    city  { Faker::Address.city }
    zip  { Faker::Address.zip_code }
    apt  { rand(400) }
  end

  factory :temp_address do
    address  { Faker::Address.street_address }
    city  { Faker::Address.city }
    zip  { Faker::Address.zip_code }
    apt  { rand(400) }
  end

  factory :perm_address do
    address  { Faker::Address.street_address }
    city  { Faker::Address.city }
    zip  { Faker::Address.zip_code }
    apt  { rand(400) }
  end
end
