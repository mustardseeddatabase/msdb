require 'faker'

FactoryGirl.define do
  factory :client do
    household_id  {rand(50)}
    firstName  {Faker::Name.first_name}
    mi {(rand(26) + 97 ).chr.upcase}
    lastName  {Faker::Name.last_name}
    suffix  {Faker::Name.suffix}
    birthdate  {Date.today - (365 * 18) - (365 * rand(10))}
    race  {Client::Races.values.sample}
    gender  {["M","F"].sample}
    headOfHousehold  {[true,false].sample}

    factory :client_with_expired_id do
      after(:build) do |c|
        c.id_qualdoc = FactoryGirl.build(:expired_id_qualdoc)
      end
    end

    factory :client_with_current_id do
      after(:build) do |c|
        c.id_qualdoc = FactoryGirl.build(:current_id_qualdoc)
      end
    end
  end
end
