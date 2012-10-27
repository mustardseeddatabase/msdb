class ClientCheckin < ActiveRecord::Base
  belongs_to :client
  belongs_to :household_checkin

  def related_client_checkins
    household_checkin.client_checkins
  end

  def clean?
    !id_warn
  end
end
