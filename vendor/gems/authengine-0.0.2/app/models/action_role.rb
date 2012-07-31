class ActionRole < ActiveRecord::Base
  belongs_to :role
  belongs_to :action

  # this is the key database lookup for checking permissions
  # returns true if there is at least one of the passed-in role ids
  # which explicitly permits (i.e. the role has action_role associations)
  # the specified controller and action
  def self.permits_access_for(controller, action, role_ids)
    joins([:role, :action => :controller ]).
      where("roles.id" => role_ids).
            where("actions.action_name" => action).
            where("controllers.controller_name" => controller).
            exists?
  end

  def self.assign_developer_access
    developer_id = Role.developer_id
    Action.all.each do |a|
      find_or_create_by_action_id_and_role_id(a.id, developer_id)
    end if developer_id
  end

  def self.bootstrap_access_for(role)
    Action.all.each do |a|
      find_or_create_by_action_id_and_role_id(a.id, role.id)
    end
  end
end
