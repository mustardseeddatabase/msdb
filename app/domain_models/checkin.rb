class Checkin
  attr_reader :id
  def initialize(client)
    @id = HouseholdCheckin.create_for(client)
  end
end
