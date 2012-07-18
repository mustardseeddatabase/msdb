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
        after(:create) do |hh|
          FactoryGirl.create(:res_qualdoc, :household => hh)
          FactoryGirl.create(:inc_qualdoc, :household => hh)
          FactoryGirl.create(:gov_qualdoc, :household => hh)
        end
      end

      factory :household_with_current_docs do
        after(:create) do |hh|
          FactoryGirl.create(:res_qualdoc, :current, :household => hh)
          FactoryGirl.create(:inc_qualdoc, :current, :household => hh)
          FactoryGirl.create(:gov_qualdoc, :current, :household => hh)
        end
      end

      factory :household_with_expired_docs do
        after(:create) do |hh|
          FactoryGirl.create(:res_qualdoc, :expired, :household => hh)
          FactoryGirl.create(:inc_qualdoc, :expired, :household => hh)
          FactoryGirl.create(:gov_qualdoc, :expired, :household => hh)
        end
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
