class PostsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :handle_params, only: :create
  
  respond_to :json, :html
  
  def index
    @post_cache_key = Post.cache_key
    @posts = Post.cached(@post_cache_key) # need paging here soon, I think
    
    respond_with @posts
  end
  
  def new
    redirect_to posts_path
  end
  
  def create
    params[:post][:user_id] = current_user.id
    
    @post = Post.new(params[:post])
    
    @asset_params.split(' ').each{ |id| @post.add_asset(id) } if @asset_params
    
    success = false
    
    if current_user && current_user.can_create_post?(@post)
      success = @post.refresh_cache_fields(true) #implies save
    end
    
    if success
      current_user.update_last_post_created_time
      respond_with @post
    else
      # need to make sure create page doesn't get cleared here on an error
      respond_with(@post, :status => :precondition_failed)
    end
  end
  
  def update
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