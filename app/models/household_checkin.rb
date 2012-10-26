class HouseholdCheckin < ActiveRecord::Base
  belongs_to :household
  has_many :client_checkins

  def self.create_for(primary_client)
    household = primary_client.household
    if household
      household_checkin = household.household_checkins.create
      @primary_checkin_id = ClientCheckin.create_collection(primary_client, household.clients, household_checkin)
    end
    @primary_checkin_id
  end

  def self.update_for(client_id, client_checkin_id, docs)
    grouped_by_association_docs = docs.group_by{|doc| doc['doctype'] == 'id' ? 'client' : 'household' }
    client_docs = grouped_by_association_docs['client']
    household_docs = grouped_by_association_docs['household']

    household_checkin_attributes = household_docs.inject({}) do |hash, doc|
      hash[doc['doctype'] + '_warn'] = doc['warned']
      hash['household_id'] ||= doc['association_id']
      hash
    end

    client_checkin = ClientCheckin.find(client_checkin_id)
    household_checkin = HouseholdCheckin.find(client_checkin.household_checkin_id)
    household_checkin.update_attributes(household_checkin_attributes)

    ClientCheckin.update_collection(client_id, client_checkin_id, client_docs, household_checkin.id)

  end

  def primary_client_checkin
    client_checkins.where('client_checkins.primary IS TRUE').first
  end

  def primary_client
    primary_client_checkin.client
  end

  def clean?
    [!res_warn, !inc_warn, !gov_warn].all?
  end

  def clean_clients?
    client_checkins.map(&:clean?).all?
  end

  def totally_clean?
    clean? && clean_clients?
  end
end
