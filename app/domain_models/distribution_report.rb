module DistributionReport
  def self.included(base)
    base.extend(ClassMethods)
  end

  module ClassMethods
    def unique_residents_in_month(date)
      unique_households_in_month(date).map(&:clients).flatten.uniq
    end

    def days_of_distribution_in_month(date)
      distributions_in_month(date).map(&:created_at).map(&:to_date).uniq
    end

    def unique_households_in_month(date)
      distributions_in_month(date).map(&:household).uniq
    end

    def distributions_in_month(date)
      in_month(date.year, date.month)
    end

    def new_households_in_month(date)
      distributions_in_month(date).select(&:new?).map(&:household).uniq
    end

    def new_residents_in_month(date)
      new_households_in_month(date).map(&:clients).flatten.uniq
    end

    def lbs_of_food_distributed_in_month(date)
      (distributions_in_month(date).map(&:distribution_items).flatten.map{|di| di.quantity * di.item.weight_oz}.sum.to_f/16).round(2)
    end
  end
end
