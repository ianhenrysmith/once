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
    # should also grab user path, user avatar here for cache fields
    
    asset_params = params[:post][:asset_ids]
    params[:post].delete(:asset_ids) if asset_params
    
    @post = Post.new(params[:post])
    asset_params.split(' ').each do |id|
      asset = Asset.find(id)
      if asset
        @post.assets << asset
        @post.asset_url = asset.photo.url
        asset.set_post_id(@post.id)
      end
    end
    
    success = false
    
    if current_user && current_user.can_create_post?(@post)
      success = @post.save
      # schedule refresh cache fields job here, I think?
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