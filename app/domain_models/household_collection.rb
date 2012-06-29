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
    clients = ClientCollection.new(households.map(&:clients).flatten)
    client_counts = clients.counts_by_age_group
    client_counts.merge!({:household => size, :homeless => homeless_resident_count})
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

end
