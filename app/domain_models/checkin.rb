class Checkin
  attr_reader :id
  attr_accessor :client, :household_checkin

  def self.create(client)
    new(:client => client).save
  end

  def initialize(attrs)
    @client = attrs[:client]
    @household_checkin = attrs[:household_checkin]
  end

  def save
    @id = HouseholdCheckin.create_for(client)
    self
  end

  def update_for(client_id, client_checkin_id, docs)
    grouped_by_association_docs = docs.group_by{|doc| doc['doctype'] == 'id' ? 'client' : 'household' }
    client_docs = grouped_by_association_docs['client']
    household_docs = grouped_by_association_docs['household']

    household_checkin_attributes = household_docs.inject({}) do |hash, doc|
      hash[doc['doctype'] + '_warn'] = doc['warned']
      hash['household_id'] ||= doc['association_id']
      hash
    end

    household_checkin.update_attributes(household_checkin_attributes)

    ClientCheckin.update_collection(client_id, client_checkin_id, client_docs, household_checkin.id)

  end

  def self.find_by_client_checkin_id(client_checkin_id)
    client_checkin = ClientCheckin.find(client_checkin_id)
    new(:household_checkin => HouseholdCheckin.find(client_checkin.household_checkin_id))
  end

end
