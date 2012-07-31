module Authengine
  module UsersHelper
  #used in the edit template to create the correct link for saving
  #this permits access control by having both "update self" action and 
  #an update action with id passed in url
    def requested_user_or_self
      @user == current_user ? update_self_authengine_user_url(@user) : authengine_user_url(@user, :method => :put)
    end

  end
end
