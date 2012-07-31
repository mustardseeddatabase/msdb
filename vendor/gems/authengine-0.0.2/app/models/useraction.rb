class Useraction < ActiveRecord::Base
  belongs_to :user
  belongs_to :action

  delegate :lastName, :to => :user, :prefix => true
  scope :expired, :conditions => ['updated_at < ?',Time.zone.now.advance(:hours => -24)]
  
  def self.create(params)
    self.name.constantize.send(:expired).each { |u| u.destroy }
    super
  end

  def self.current
    eval("Useraction#{current_index}")
  end

  def self.date_range
    t = Time.zone.now.to_date
    t.advance(:days => -4) .. t
  end

  # if current index = 2
  #     i     days before today
  #     0     2
  #     1     1
  #     2     0
  #     3     4
  #     4     3
  def self.date_of_index(i)
    Time.zone.now.to_date.advance(:days => -((current_index - i)%5))
  end

  def params_truncated
    # because some requests, especially the "actions" controller, produce huge params fields, with little value
    # so we display a truncated version only (but full params are stored
    # in the db, available for display if necessary).
     if params.to_s.size > 80
       p = params.to_s[0..80]+" ...more"
     else
       p = params.to_s
     end
     p.gsub(/^\{|\}$/,"") # remove start/end braces
  end

  private

  def self.current_index
    (Time.zone.now.to_datetime - Date.new(2011,1,1)).to_i.%5
  end
end

class Useraction0 < Useraction; end
class Useraction1 < Useraction; end
class Useraction2 < Useraction; end
class Useraction3 < Useraction; end
class Useraction4 < Useraction; end
