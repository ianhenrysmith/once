class UsersController < ApplicationController
  before_filter :authenticate_user!
  
  respond_to :json, :html
  
  def index
  end
  
  def show
    @user = User.find(params[:id])
    
    if stale?( @user )
      respond_with @user
    end
  end
  
  def edit
    @user = User.find(params[:id])
    
    if stale?( @user )
      respond_with @user
    end
  end
  
  def update
    @user = User.find(params[:id])
    if @user.try(:id) == current_user.id
      #this should probably be some sort of before filter
      if asset_params = params[:asset_ids]
        params[:user].delete(:asset_ids)
        ## Plans here: 
        ##  handle multiple assets better
        ##  dont dup assets
        ##  abstract this method to a base model class
        asset_params.split(' ').each do |id|
          asset = Asset.find(id)
          if asset
            @user.assets << asset
            @user.asset_url = asset.photo.url
            asset.set_post_id(@user.id)
          end
        end
      end
      @user.update_attributes(params[:user])
    end
    respond_with @user
  end
end
