class Checkin
  class InvalidClientError < StandardError; end
  class InvalidHouseholdCheckinError < StandardError; end
  attr_reader :id
  attr_accessor :client, :household_checkin, :household, :client_checkins

  def self.create(client)
    new(:client => client).save
  end

  def initialize(attrs)
    @client = attrs[:client]
    if @client
      raise InvalidClientError if !@client.is_a?(Client)
      @household = @client.household
      raise InvalidClientError if !@household
    end
    @household_checkin = attrs[:household_checkin] || HouseholdCheckin.new(:household_id => household.id)
    raise InvalidHouseholdCheckinError if !@household_checkin.is_a?(HouseholdCheckin)
    if household_checkin = attrs[:household_checkin]
      @household = Household.find(household_checkin.household_id)
    end
    @client_checkins = attrs[:client_checkins].blank? ?
                         @household.clients.collect { |c| ClientCheckin.new(:client_id => c.id, :household_checkin => household_checkin) } :
                         attrs[:client_checkins]
  end

  def save
    household_checkin.save
    client_checkins.each do |cc|
      cc.household_checkin_id = household_checkin.id
      if cc.client_id == client.id
        cc.primary = true
      end
      cc.save
      @id = cc.id
    end
    self
  end

  def update_for(client_id, client_checkin_id, docs)
    client_docs = docs.select{|doc| doc['doctype'] == 'id'}
    household_docs = docs.select{|doc| doc['doctype'] != 'id'}

    household_checkin_attributes = HouseholdCheckin.extract_attributes_from_docs(household_docs)

    household_checkin.update_attributes(household_checkin_attributes)

    client_checkins.each do |checkin|
      doc = client_docs.detect{|doc| doc[:association_id].to_i == checkin.client_id}
      checkin.update_attributes(:id_warn => (doc['warned'] == "true") || doc['warned'] == '1')
    end
  end

  def self.find_by_client_checkin_id(client_checkin_id)
    client_checkin = ClientCheckin.find(client_checkin_id)
    client = Client.find(client_checkin.client_id)
    household_checkin = HouseholdCheckin.find(client_checkin.household_checkin_id)
    client_checkins = ClientCheckin.where('household_checkin_id = ?',household_checkin.id)
    new(:household_checkin => household_checkin, :client_checkins => client_checkins, :client => client)
  end

end
