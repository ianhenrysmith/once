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
    params[:post][:user_id] = current_user.id
    params[:post][:type] ||= "text"
    @post = Post.new(params[:post])
    success = false
    
    if current_user && current_user.can_create_post?(@post)
      success = @post.save
    end
    
    if success
      current_user.update_last_post_created_time
      respond_with @post
    else
      respond_with(@post, :status => :precondition_failed)  # user probably already created a post today
    end
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