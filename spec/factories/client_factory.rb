require 'faker'

FactoryGirl.define do
  factory :client do
    household_id  {rand(50)}
    firstName  {Faker::Name.first_name}
    mi {(rand(26) + 97 ).chr.upcase}
    lastName  {Faker::Name.last_name}
    suffix  {Faker::Name.suffix}
    birthdate  {Date.new!(2430000+ rand(25000))}
    race  {Client::Races.values.sample}
    gender  {["M","F"].sample}
    headOfHousehold  {[true,false].sample}

    factory :client_with_expired_id do
      after_build do |c|
        c.id_qualdoc = Factory.build(:expired_id_qualdoc)
      end
    end

    factory :client_with_current_id do
      after_build do |c|
        c.id_qualdoc = Factory.build(:current_id_qualdoc)
      end
    end
  end
end
