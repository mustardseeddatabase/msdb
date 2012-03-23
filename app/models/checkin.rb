# when the head of household checks in, a proxy checkin is also created for household members
# so that id warnings about household members can be saved as well as id, gov, inc, res warnings
# for the head of household.
class Checkin < ActiveRecord::Base
  belongs_to :client

  has_many :proxy_checkins, :class_name => 'Checkin', :foreign_key => :parent_id, :autosave => true
  belongs_to :parent_checkin, :class_name => 'Checkin', :foreign_key => :parent_id

  def primary?
    parent_id.nil?
  end

  def totally_clean?
    clean? && proxies_clean?
  end

  def clean?
    ![id_warn, res_warn, inc_warn, gov_warn].any?
  end

  def proxies_clean?
    proxy_checkins.map(&:clean?).all?
  end
end
