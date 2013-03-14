class AjaxController < ApplicationController
  before_filter :authenticate_user!
  
  respond_to :json
  
  def send_action(junk={})
    params[:options] ||= {}
    
    # needs params: id, class name, resource action name, options for action
    klass = params[:class].capitalize.try(:constantize)
    if klass.try{ |c| c::AJAX_ACTIONS.include? params[:resource_action] }
      if params[:id].present?
        resource = klass.try{ |c| c.find(params[:id]) }
        options = {}.merge params[:options]
        options[:user] = current_user
        resource.try{ |r| r.send(params[:resource_action], options) } # need some sort of action permission check here, probably should use cancan
      else
        klass.try{ |c| c.send(params[:resource_action], options)}
      end
    end
    
    resource ||= nil
    respond_with resource
  end
end