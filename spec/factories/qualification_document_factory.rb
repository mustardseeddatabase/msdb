include ActionDispatch::TestProcess

FactoryGirl.define do
  factory :id_qualdoc do
    confirm  [true,false].sample
    date  {Date.today - rand(365)}
    warnings  0
    vi  [true,false].sample
    after_build do |iq|
      iq.send("write_attribute", :docfile, "arbogast_id.pdf")
    end

    factory :current_id_qualdoc do
      date 1.month.ago
    end

    factory :expired_id_qualdoc do
      date 1.year.ago
    end
  end

  factory :res_qualdoc do
    confirm  [true,false].sample
    date  {Date.today - rand(365)}
    warnings  0
    vi  [true,false].sample
    after_build do |rq|
      rq.send("write_attribute", :docfile, "arbogast_id.pdf")
    end

    factory :current_res_qualdoc do
      date 1.month.ago
    end

    factory :expired_res_qualdoc do
      date 1.year.ago
    end
  end

  factory :inc_qualdoc do
    confirm  [true,false].sample
    date  {Date.today - rand(365)}
    warnings  0
    vi  [true,false].sample
    after_build do |iq|
      iq.send("write_attribute", :docfile, "arbogast_id.pdf")
    end

    factory :current_inc_qualdoc do
      date 1.month.ago
    end

    factory :expired_inc_qualdoc do
      date 1.year.ago
    end
  end

  factory :gov_qualdoc do
    confirm  [true,false].sample
    date  {Date.today - rand(365)}
    warnings  0
    vi  [true,false].sample
    after_build do |gq|
      gq.send("write_attribute", :docfile, "arbogast_id.pdf")
    end

    factory :current_gov_qualdoc do
      date 1.month.ago
    end

    factory :expired_gov_qualdoc do
      date 1.year.ago
    end
  end
end
