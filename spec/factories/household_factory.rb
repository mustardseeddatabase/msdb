require 'faker'

FactoryGirl.define do
  factory :household do
    phone  {Faker::PhoneNumber.phone_number}
    email  {Faker::Internet.email}
    resident_count  {rand(20)}
    income  {rand(40)*1000}
    otherConcerns  {Faker::Lorem.paragraph}

    association :perm_address, :factory => :perm_address
    association :temp_address, :factory => :temp_address

      factory :household_with_docs do
        after_create do |hh|
          Factory.create(:res_qualdoc, :association_id => hh.id)
          Factory.create(:inc_qualdoc, :association_id => hh.id)
          Factory.create(:gov_qualdoc, :association_id => hh.id)
        end
      end

      factory :household_with_current_docs do
        after_create do |hh|
          Factory.create(:current_res_qualdoc, :association_id => hh.id)
          Factory.create(:current_inc_qualdoc, :association_id => hh.id)
          Factory.create(:current_gov_qualdoc, :association_id => hh.id)
        end
      end

      factory :household_with_expired_docs do
        after_create do |hh|
          Factory.create(:expired_res_qualdoc, :association_id => hh.id)
          Factory.create(:expired_inc_qualdoc, :association_id => hh.id)
          Factory.create(:expired_gov_qualdoc, :association_id => hh.id)
        end
      end # /factory
  end # /factory

end # /define
