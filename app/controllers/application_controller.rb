class ApplicationController < ActionController::Base
  protect_from_forgery
  
  def index
  end
  
  private
  
  def handle_params
    # have to make this work for user too
    @asset_params = params[:post].delete(:asset_ids)
  end
end
