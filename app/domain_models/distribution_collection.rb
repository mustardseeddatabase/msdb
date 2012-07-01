class DistributionCollection
  attr_accessor :distributions

  def initialize(date)
    @distributions = Distribution.in_month(date.year, date.month).includes(:household => [:clients, :distributions], :distribution_items => :item)
  end

  def days_of_distribution
    distributions.map(&:created_at).map(&:to_date).uniq
  end

  def unique_households
    distributions.map(&:household).uniq
  end

  def unique_residents
    unique_households.map(&:clients).flatten.uniq
  end

  def new_households
    distributions.select(&:new?).map(&:household).uniq
  end

  def new_residents
    new_households.map(&:clients).flatten.uniq
  end

  def lbs_of_food_distributed
    distributions.map(&:weight_lb).sum.round(2)
  end
end
