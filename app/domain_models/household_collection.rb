class HouseholdCollection
  attr_accessor :households

  def initialize(collection)
    @households = collection
  end

  def report_demographics(date)
    grouped_households = {:new => {}, :continued => {}}.merge! households.group_by{|hh| hh.new_or_continued_in_month(date.year, date.month)}
    grouped_clients = {'M' => {}, 'F' => {}}.merge! clients.group_by(&:gender)
    grouped_household_demographics = grouped_households.inject({}) do |hash, (k,hhh)|
      hash[k] = HouseholdCollection.new(hhh).aggregated_age_group_demographics
      hash
    end
    grouped_client_demographics = grouped_clients.inject({}) do |hash, (mf, cc)| # mf is :male or :female, cc is a collection of clients
      mf = case mf
           when 'M'
             :male
           when 'F'
             :female
           else
             nil
           end
      hash[mf] = ClientCollection.new(cc).aggregated_race_demographics
      hash
    end

    totals = {:total => aggregated_age_group_demographics.merge(ClientCollection.new(clients).aggregated_race_demographics)}

    results = grouped_household_demographics.merge(grouped_client_demographics).merge(totals)
    [results, clients.select(&:has_report_errors).uniq.sort_by{|c| c.lastName || ''}]
  end

  # sums the demographic values for each of the households in the collection
  def aggregated_age_group_demographics
    client_collection = ClientCollection.new(clients).counts_by_age_group
    client_collection.merge!({:household => size, :homeless => homeless_resident_count})
  end

  def ssi_count
    households.select(&:ssi?).length
  end

  def food_stamp_count
    households.select(&:foodstamps?).length
  end

  def medicaid_count
    households.select(&:medicaid?).length
  end

  def government_assistance
    [
      ['Supplemental Security Assistance', ssi_count],
      ['Food Stamps', food_stamp_count],
      ['Medicaid', medicaid_count]
    ]
  end

  def physically_disabled_count
    households.select(&:physDisabled?).length
  end

  def mentally_disabled_count
    households.select(&:mentDisabled?).length
  end

  def single_parent_count
    households.select(&:singleParent?).length
  end

  def diabetic_count
    households.select(&:diabetic?).length
  end

  def retired_count
    households.select(&:retired?).length
  end

  def unemployed_count
    households.select(&:unemployed?).length
  end

  def homeless_count
    households.select(&:homeless?).length
  end

  def special_circumstances
    [
      ['Physically disabled', physically_disabled_count ],
      ['Mentally disabled', mentally_disabled_count ],
      ['Single parent', single_parent_count ],
      ['Diabetic', diabetic_count ],
      ['Retired', retired_count ],
      ['Unemployed', unemployed_count ],
      ['Homeless', homeless_count ]
    ]
  end

  def size
    households.size
  end

  def homeless_resident_count
    households.select(&:homeless).map(&:clients).flatten.count
  end

  def clients
    households.map(&:clients).flatten.uniq
  end

  def length
    households.uniq.length
  end

  def new(date)
    households.select{|h| h.new_in?(date.year, date.month)}.uniq
  end

  def new_clients(date)
    new(date).map(&:clients).uniq.length
  end

  def income_ranges
    range_count = Household.blank_income_range_count
    grouped_households = households.group_by(&:income_range)
    range_count.merge!(grouped_households) do |range, c1, c2|
      client_count = c2 && c2.map(&:clients).flatten.length
      {:household_count => c2.length,
       :resident_count => client_count}
    end
  end

  def zip_codes
    counts = households.group_by(&:permanent_zip).inject([]) do |arr, (zip,hh)|
                arr << [zip || "Unknown", {:household_count => hh.length, :resident_count => hh.map(&:clients).flatten.length}]
                arr
              end
    counts.sort_by!{|el| el[0].to_i}
  end

  def family_structures
    structures = {"one person household" => 0,
                  "single male parent" => 0,
                  "single female parent" => 0,
                  "couple w/ children" => 0,
                  "couple w/o children" => 0,
                  "other family structure" => 0 }
    groups = households.group_by(&:family_structure)
    structures.merge(groups){|k,c1,c2| c2.length}
  end

end
