FactoryGirl.define do
  factory :distribution do
    household_id {rand(50)}
    created_at {Date.today}
  end
end
