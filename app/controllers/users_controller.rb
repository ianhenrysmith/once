class UsersController < ApplicationController
  load_and_authorize_resource
  
  before_filter :authenticate_user!, except: [:show]
  before_filter :handle_params, only: [:create, :update]
  before_filter :handle_asset_params, only: [:create, :update]
  
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
    respond_with @user.update_attributes(params[:user])
  end
  
  private
  
  def handle_params
    params[:user][:assets_attributes] ||= []
    
    @asset_params = params.delete(:model_asset_ids).split(" ") if params[:model_asset_ids]
  end
  
  def handle_asset_params
    params[:user] ||= {}
    params[:user][:assets] = (@user && @user.assets) ? @user.assets : []
    
    if @asset_params.present?
      @asset_params.each do |id| 
        if asset = Asset.find(id)
          params[:user][:assets] << asset
          params[:user][:asset_url] = asset.asset_image.url
          asset.set_owner(@user.id, @user.class) if @user
        end
      end  
    end
    
  end
end
