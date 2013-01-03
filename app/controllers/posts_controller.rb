class PostsController < ApplicationController
  before_filter :authenticate_user!
  
  respond_to :json, :html
  
  def index
    posts = Post.all
    if params[:user_id]
      posts = Post.where(:user_id => params[:user_id]).all
    end
    respond_with posts
  end
  
  def new
    redirect_to posts_path
  end
  
  def create
    params[:post][:user_id] ||= current_user.id
    params[:post][:type] ||= "text"
    post = Post.create(params[:post])
    respond_with post 
  end
  
  def update
    respond_with Post.update(params[:id], params[:post])
  end
    
  def destroy
    respond_with Post.find(params[:id]).destroy
  end
  
  def show
    respond_with Post.find(params[:id])
  end
end