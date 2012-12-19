class PostsController < ApplicationController
  before_filter :authenticate_user!
  
  respond_to :json
  
  def index
    respond_with Post.all
  end
  
  def create
    respond_with Post.create(params[:post])
  end
  
  def update
    respond_with Post.update(params[:id], params[:post])
  end
    
  def destroy
    respond_with Post.destroy(params[:id])
  end
end