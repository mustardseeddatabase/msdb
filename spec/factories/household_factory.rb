require 'faker'

FactoryGirl.define do
  factory :household do
    phone  {Faker::PhoneNumber.phone_number}
    email  {Faker::Internet.email}
    income  {rand(40)*1000}
    otherConcerns  {Faker::Lorem.paragraph}

    perm_address
    temp_address

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

      trait :homeless do
        homeless true
      end
  end # /factory

end # /define
