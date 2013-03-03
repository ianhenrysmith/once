class UsersController < ApplicationController
  load_and_authorize_resource
  
  before_filter :authenticate_user!, except: [:show]
  before_filter :handle_params, only: [:create, :update]
  
  respond_to :json, :html
  
  def index
  end
  
  def show    
    if stale?( @user )
      respond_with @user
    end
  end
  
  def edit    
    if stale?( @user )
      respond_with @user
    end
  end
  
  def update
    if @asset_params.present?
      @asset_params.each{ |id| @user.add_asset(id) }
    end
    
    respond_with @user.update_attributes(params[:user])
  end
  
  private
  
  def handle_params
    params[:user][:assets_attributes] ||= []
    @asset_params = params.delete(:model_asset_ids).split(" ") if params[:model_asset_ids]
  end
end
