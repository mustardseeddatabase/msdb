class ClientCheckin < ActiveRecord::Base
  belongs_to :client
  belongs_to :household_checkin

  def self.create_collection(primary_client, clients, household_checkin)
    clients.each do |client|
      primary = client == primary_client
      checkin = create(:client_id => client.id, :household_checkin_id => household_checkin.id, :primary => primary, :id_warn => false)
      @primary_checkin_id = checkin.id if primary
    end
    @primary_checkin_id
  end

  def self.update_collection(client_id, client_checkin_id, docs, household_checkin_id)
    collection = where('household_checkin_id = ?', household_checkin_id)
    collection.each do |checkin|
      doc = docs.detect{|doc| doc[:association_id].to_i == checkin.client_id}
      checkin.update_attributes(:id_warn => (doc['warned'] == "true") || doc['warned'] == '1')
    end
    client_checkin_id
  end

  def related_client_checkins
    household_checkin.client_checkins
  end

  def clean?
    !id_warn
  end
end
