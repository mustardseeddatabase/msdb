class HouseholdCollection
  attr_accessor :households

  def initialize(collection)
    @households = collection
  end

  def report_demographics(date)
    grouped_households = {:new => {}, :continued => {}}.merge! households.group_by{|hh| hh.new_or_continued_in_month(date.year, date.month)}
    grouped_demographics = grouped_households.inject({}) do |hash, (k,hhh)|
                              hash[k] = HouseholdCollection.new(hhh).aggregated_demographics
                              hash
                            end
    grouped_demographics.merge({:total => aggregated_demographics})
  end

  # sums the demographic values for each of the households in the collection
  def aggregated_demographics
    blank_counts = { :children => 0,
                     :adults => 0,
                     :seniors => 0,
                     :AA => 0,
                     :AS => 0,
                     :HI => 0,
                     :WH => 0,
                     :UNK => 0,
                     :homeless => 0,
                     :total => 0 } # to deal with the pathological case that no households are passed-in
    households.inject(blank_counts){|hash,hh| hash.merge!(hh.demographic){|k,a,b| a+b}; hash}
  end

end
