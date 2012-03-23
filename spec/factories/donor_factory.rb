Factory.define :donor do |d|
  d.organization {Faker::Company.name}
  d.contactName {Faker::Name.name}
  d.contactTitle ["Agency Relations Manager", "Bethlehem Volunteer Center Camp Manager", "Director", "Pastor", "Principal", "Teacher", "Volunteer", "Volunteer Coordinator"].sample
  d.address {Faker::Address.street_address}
  d.city {Faker::Address.city}
  d.state {STATES.sample} # because Faker has 62 state abbreviations but the app only has 50!
  d.zip {Faker::Address.zip_code}
  d.phone {Faker::PhoneNumber.phone_number}
  d.fax {Faker::PhoneNumber.phone_number}
  d.email {Faker::Internet.email}
end
