class Authengine::ActionsController < ApplicationController
  layout 'authengine/layouts/authengine'

  def index
    Controller.update_table # make sure the actions table includes all current controllers/actions
    @actions = Action.all(:include=>:controller).sort
    @roles = Role.all(:include=>{:actions=>:controller}, :order=>:name) # this eager loading seems to produce a large number of database accesses, and I'm not sure why!!
    @allowed = []
    @roles.each{ |r| @allowed[r.id]= r.name=="developer" ? @actions.map(&:id) : r.actions.map{ |a| a.id unless a.nil? } }
  end

  def update
    ActionRole.update_all(params)
    redirect_to (authengine_actions_url)
  end

end
