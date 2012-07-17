class CreateWithoutValidationStrategy
  def initialize
    @strategy = FactoryGirl.strategy_by_name(:build).new
  end

  delegate :association, to: :@strategy

  def result(evaluation)
    @strategy.result(evaluation).save(:validate => false)
    @strategy.result(evaluation)
  end
end

FactoryGirl.register_strategy(:create_without_validation, CreateWithoutValidationStrategy)
