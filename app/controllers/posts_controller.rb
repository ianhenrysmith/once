class PostsController < ApplicationController
  before_filter :authenticate_user!
  
  respond_to :json, :html
  
  def index
    @posts = Post.all
    @users = User.all
    
    respond_with @posts
  end
  
  def new
    redirect_to posts_path
  end
  
  def create
    params[:post][:user_id] = current_user.id
    params[:post][:type] ||= "text"
    
    asset_params = params[:post][:asset_ids]
    params[:post].delete(:asset_ids)
    
    @post = Post.new(params[:post])
    @post.assets.build
    asset_params.split(' ').each do |id|
      asset = Asset.find(id)
      @post.assets << asset
    end
    
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
    # debugger
    @post = Post.find(params[:id])
    respond_with @post.update_attributes(params[:post])
  end
    
  def destroy
    respond_with Post.find(params[:id]).destroy
  end
  
  def show
    respond_with Post.find(params[:id])
  end
end