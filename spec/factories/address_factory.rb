require 'faker'

Factory.define :address do |address|
    address.address  { Faker::Address.street_address }
    address.city  { Faker::Address.city }
    address.zip  { Faker::Address.zip_code }
    address.apt  { rand(400) }
end

Factory.define :temp_address do |address|
    address.address  { Faker::Address.street_address }
    address.city  { Faker::Address.city }
    address.zip  { Faker::Address.zip_code }
    address.apt  { rand(400) }
end

Factory.define :perm_address do |address|
    address.address  { Faker::Address.street_address }
    address.city  { Faker::Address.city }
    address.zip  { Faker::Address.zip_code }
    address.apt  { rand(400) }
end
