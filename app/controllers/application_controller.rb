class ApplicationController < ActionController::Base
  protect_from_forgery
  
  layout "application"
  
  def index
  end
  
  private
  
  def layout
    # set layout for devise controllers:
    devise_controller? && "application"
  end
end
