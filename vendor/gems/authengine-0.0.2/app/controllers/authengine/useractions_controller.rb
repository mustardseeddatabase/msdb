class Authengine::UseractionsController < ApplicationController
  layout 'authengine/layouts/authengine'
  
  def show
    eval("@useractions = Useraction#{params[:actionlog_id].to_i}.all.map{|u| u.becomes(Useraction)}")
    @date = Useraction.date_of_index(params[:actionlog_id].to_i)
    @sort_criteria = [ :created_at, :user_lastName ]
  end
  
  def index
    dates = (0..4).to_a.inject({}) do |hash,index|
      hash.merge!( index => Useraction.date_of_index(index) )
      hash
    end
    @dates = dates.invert
  end
end
