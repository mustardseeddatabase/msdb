FactoryGirl.define do
  factory :donor do
    organization {Faker::Company.name}
    contactName {Faker::Name.name}
    contactTitle ["Agency Relations Manager", "Bethlehem Volunteer Center Camp Manager", "Director", "Pastor", "Principal", "Teacher", "Volunteer", "Volunteer Coordinator"].sample
    address {Faker::Address.street_address}
    city {Faker::Address.city}
    state {STATES.sample} # because Faker has 62 state abbreviations but the app only has 50!
    zip {Faker::Address.zip_code}
    phone {Faker::PhoneNumber.phone_number}
    fax {Faker::PhoneNumber.phone_number}
    email {Faker::Internet.email}
  end
end
