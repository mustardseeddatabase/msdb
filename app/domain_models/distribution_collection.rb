class DistributionCollection
  attr_accessor :distributions

  def initialize(date)
    @distributions = Distribution.in_month(date.year, date.month).includes(:household => [:clients, :distributions], :distribution_items => :item)
  end

  def length
    distributions.length
  end

  def days_of_distribution
    distributions.map(&:created_at).map(&:to_date).uniq.length
  end

  def lbs_of_food_distributed
    distributions.map(&:weight_lb).sum.round(2)
  end
end
