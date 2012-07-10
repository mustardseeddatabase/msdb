include ActionDispatch::TestProcess

FactoryGirl.define do
  factory :qualification_document do
    confirm  [true,false].sample
    date  {Date.today - Kernel.rand(365)}
    warnings  0
    vi  [true,false].sample

    trait :current do
      date 1.month.ago
    end

    trait :expired do
      date 1.year.ago
    end

    factory :id_qualdoc, :class => IdQualdoc do
      sourcefile = Proc.new{Rails.root.join("tmp","factory_id_qualdoc#{Kernel.rand(1000000000000)}.txt")}
      type "IdQualdoc"
      before(:create) do |doc| # don't create a document when strategy is 'build'
        doc.docfile = File.open(sourcefile.call,"w+")
      end
      after(:create) do |doc|
        `rm -f #{Rails.root.join("tmp",doc.docfile.file.original_filename)}`
      end
    end

    factory :res_qualdoc, :class => ResQualdoc do
      sourcefile = Proc.new{Rails.root.join("tmp","factory_res_qualdoc#{Kernel.rand(1000000000000)}.txt")}
      type "ResQualdoc"
      before(:create) do |doc| # don't create a document when strategy is 'build'
        doc.docfile = File.open(sourcefile.call,"w+")
      end
      after(:create) do |doc|
        `rm -f #{Rails.root.join("tmp",doc.docfile.file.original_filename)}`
      end
    end

    factory :inc_qualdoc, :class => IncQualdoc do
      sourcefile = Proc.new{Rails.root.join("tmp","factory_inc_qualdoc#{Kernel.rand(1000000000000)}.txt")}
      type "IncQualdoc"
      before(:create) do |doc| # don't create a document when strategy is 'build'
        doc.docfile = File.open(sourcefile.call,"w+")
      end
      after(:create) do |doc|
        `rm -f #{Rails.root.join("tmp",doc.docfile.file.original_filename)}`
      end
    end

    factory :gov_qualdoc, :class => GovQualdoc do
      sourcefile = Proc.new{Rails.root.join("tmp","factory_gov_qualdoc#{Kernel.rand(1000000000000)}.txt")}
      type "GovQualdoc"
      before(:create) do |doc| # don't create a document when strategy is 'build'
        doc.docfile = File.open(sourcefile.call,"w+")
      end
      after(:create) do |doc|
        `rm -f #{Rails.root.join("tmp",doc.docfile.file.original_filename)}`
      end
    end
  end
end
