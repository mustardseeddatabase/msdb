require 'faker'

FactoryGirl.define do
  factory :user do
    login {Faker::Name.last_name}
    email {Faker::Internet.email}
    activated_at {Date.today - rand(365)}
    enabled 1
    firstName {Faker::Name.first_name}
    lastName {Faker::Name.last_name}
  end
end

