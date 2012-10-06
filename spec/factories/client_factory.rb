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
        c.id_qualdoc = FactoryGirl.build(:id_qualdoc, :expired)
      end
    end

    factory :client_with_current_id do
      after(:build) do |c|
        c.id_qualdoc = FactoryGirl.build(:id_qualdoc, :current)
      end
    end

    factory :client_with_blank_lastName do
      after(:create) do |c|
        c.update_attribute(:lastName, nil)
      end
    end

    trait :infant do
			birthdate 3.years.ago
		end
    trait :youth  do
			birthdate 7.years.ago
		end
    trait :adult  do
			birthdate 27.years.ago
		end
    trait :senior_adult  do
			birthdate 67.years.ago
		end
    trait :elder  do
			birthdate 77.years.ago
		end

    trait :male do
			gender "M"
		end
    trait :female do
			gender "F"
		end

    trait :AA do
      race "AA"
    end
    trait :AS do
      race "AS"
    end
    trait :HI do
      race "HI"
    end
    trait :WH do
      race "WH"
    end
    trait :OT do
      race "OT"
    end
  end #/:client
end #/FactoryGirl
