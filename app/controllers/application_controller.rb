class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :check_permissions

  unless Msdb::Application.config.consider_all_requests_local
    rescue_from NoMethodError, :with => :no_method_error
  end

private
  def no_method_error(exception)
    render :template => "/errors/404.html.haml", :status => 404
  end

end
