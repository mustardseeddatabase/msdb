class Authengine::ActionRolesController < ApplicationController
  layout 'authengine/layouts/authengine'

  def update_all
    aa = ActionRole.all.group_by(&:role_id).inject({}){|hash,a| hash[a[0]]=a[1].collect(&:action_id); hash}
    params[:permission].each do |role_id,permissions| # role is the role name, permissions is a hash of controller/action names
       role_id = role_id.to_i
       permissions.each do |action_id, val|
         action_id = action_id.to_i
         a = aa[role_id].nil? ? false : aa[role_id].include?(action_id) # because a new role, with no permissions granted, produces nil for aa[role_id.to_i]
         if val=="1" && !a # a newly-checked checkbox
           ActionRole.new(:role_id=>role_id,:action_id=>action_id).save
         elsif val=="0" && a # a newly-unchecked checkbox
           ActionRole.find_by_role_id_and_action_id(role_id,action_id).delete
         end
      end
    end

    redirect_to authengine_actions_url
  end

end
