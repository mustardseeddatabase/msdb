require 'faker'

FactoryGirl.define do
  factory :household do
    phone  {Faker::PhoneNumber.phone_number}
    email  {Faker::Internet.email}
    income  {rand(40)*1000}
    otherConcerns  {Faker::Lorem.paragraph}

    association :perm_address, strategy: :build
    association :temp_address, strategy: :build

      factory :household_with_docs do
        association :res_qualdoc, :strategy => :build
        association :inc_qualdoc, :strategy => :build
        association :gov_qualdoc, :strategy => :build
      end

      factory :household_with_current_docs do
        association :res_qualdoc, :current, :strategy => :build
        association :inc_qualdoc, :current, :strategy => :build
        association :gov_qualdoc, :current, :strategy => :build
      end

      factory :household_with_expired_docs do
        association :res_qualdoc, :expired, :strategy => :build
        association :inc_qualdoc, :expired, :strategy => :build
        association :gov_qualdoc, :expired, :strategy => :build
      end # /factory

      trait :with_docs do
        res_qualdoc
        inc_qualdoc
        gov_qualdoc
      end

      trait :with_errored_clients do
        after(:build) do |hh|
          hh.clients << FactoryGirl.create_without_validation(:client, :birthdate => nil)
          hh.clients << FactoryGirl.create(:client, :race => nil)
          hh.clients << FactoryGirl.create(:client, :gender => nil)
        end
      end

      trait :homeless do
        homeless true
      end
  end # /factory

end # /define
