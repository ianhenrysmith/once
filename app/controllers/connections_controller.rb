class ConnectionsController < ApplicationController
  load_and_authorize_resource
  
  before_filter :authenticate_user!
  
  respond_to :json, :html

  def create
    @connection.save
    
    respond_with @connection
  end
end