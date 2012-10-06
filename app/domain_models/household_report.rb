module HouseholdReport

  IncomeRanges = {
    "Under $10,000" => (0..9999),
    "$10,000 - $24,999" => (10000..24999),
    "$25,000 - $34,999" => (25000..34999),
    "$35,000 - $49,999" => (35000..49999),
    "$50,000 and above" => (50000..9999999999999999999999999999),
    "Unknown" => nil
  }

  def self.included(base)
    base.extend(ClassMethods)
  end

  module ClassMethods
    def blank_income_range_count
      IncomeRanges.keys.inject({}){|hash,range| hash[range] = {:household_count => 0, :resident_count => 0}; hash}
    end
  end

  def income_range
    case income
    when IncomeRanges["Under $10,000"]
      "Under $10,000"
    when IncomeRanges["$10,000 - $24,999"]
      "$10,000 - $24,999"
    when IncomeRanges["$25,000 - $34,999"]
      "$25,000 - $34,999"
    when IncomeRanges["$35,000 - $49,999"]
      "$35,000 - $49,999"
    when IncomeRanges["$50,000 and above"]
      "$50,000 and above"
    when nil
      "Unknown"
    end
  end

  def count_by_homeless
    value = homeless? ? 1 : 0
    {:homeless => value}
  end

  def new_or_continued_in_month(year,month)
    date_of_first_distribution = distributions.sort_by(&:created_at).first.created_at
    new = (date_of_first_distribution.year == year) && (date_of_first_distribution.month == month)
    new ? :new : :continued
  end

  def new_in?(year,month)
    new_or_continued_in_month(year,month) == :new
  end

  def family_structure
    if clients.size == 1
      "one person household"
    elsif one_male_adult && child_count > 0
      "single male parent"
    elsif one_female_adult && child_count > 0
      "single female parent"
    elsif adult_count == 2 && child_count > 0
      "couple w/ children"
    elsif adult_count == 2 && child_count == 0
      "couple w/o children"
    else
      "other family structure"
    end
  end

  def one_male_adult
    adults = clients.select(&:adult)
    adult_males = adults.select(&:male)
    (adult_count == 1) && (adult_males.length == 1)
  end

  def one_female_adult
    adults = clients.select(&:adult)
    adult_females = adults.select(&:female)
    (adult_count == 1) && (adult_females.length == 1)
  end

  def adult_count
    clients.select(&:adult).length
  end

  def child_count
    clients.select(&:child).length
  end
end
