class UsersController < ApplicationController
  before_filter :authenticate_user!
  
  respond_to :json, :html
  
  def index
  end
  
  def show
    @user = User.find(params[:id]) if params && params[:id].present?
  end
  
  def update
    @user = User.find(params[:id])
    
    if @user
      @user.update_attributes(params[:user])
      respond_with @user
    end
  end
end
