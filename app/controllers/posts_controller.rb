class PostsController < ApplicationController
  load_and_authorize_resource
  
  before_filter :authenticate_user!
  before_filter :handle_params, only: [:create, :update]
  
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
    debugger # want to see if post.new is done by cancan
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
    respond_with @post.update_attributes(params[:post])
  end
    
  def destroy
    respond_with @post.destroy
  end
  
  def show
    respond_with @post
  end
  
  private
  
  def handle_params
    
    params[:post].delete(:id)
    params[:post].delete(:_id)
    params[:post].delete(:updated_at)
    params[:post].delete(:created_at)
    
    params[:post][:assets_attributes] ||= []
    @asset_params = params[:post].delete(:asset_ids)
  end
end