include ActionDispatch::TestProcess

FactoryGirl.define do
  factory :qualification_document do
    confirm  [true,false].sample
    date  {Date.today - rand(365)}
    warnings  0
    vi  [true,false].sample
    after(:build) do |iq|
      iq.send("write_attribute", :docfile, "arbogast_id.pdf")
    end

    trait :current do
      date 1.month.ago
    end

    trait :expired do
      date 1.year.ago
    end

    factory :id_qualdoc, :class => IdQualdoc do
      type "IdQualdoc"
    end

    factory :res_qualdoc, :class => ResQualdoc do
      type "ResQualdoc"
    end

    factory :inc_qualdoc, :class => IncQualdoc do
      type "IncQualdoc"
    end

    factory :gov_qualdoc, :class => GovQualdoc do
      type "GovQualdoc"
    end
  end
end
