class ClientCheckin < ActiveRecord::Base
  belongs_to :client
  belongs_to :household_checkin

  def self.update_collection(client,docs,household_checkin_id)
    docs.each do |doc|
      create(:client_id => doc['association_id'],
             :id_warn => doc['warned'],
             :household_checkin_id => household_checkin_id,
             :primary => client.id == doc['association_id'].to_i)
    end
  end

  def related_client_checkins
    household_checkin.client_checkins
  end

  def clean?
    !id_warn
  end
end
