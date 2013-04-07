class PostsController < ApplicationController
  load_and_authorize_resource
  
  before_filter :authenticate_user!, except: [:index]
  before_filter :handle_params, only: [:create, :update]
  before_filter :handle_asset_params, only: [:create, :update]
  
  respond_to :json, :html
  
  def index
    if Rails.env.development? && current_user && ( current_user.id == User.test_user.id )
      @posts = Post.test_posts
    else
      @posts = Post.all
    end
        
    respond_with @posts
  end
  
  def new
    redirect_to posts_path
  end
  
  def create
    if @post.update_attributes(params[:post])
      # ^^^^ this is the 2nd save b/c post is saved in load_and_authorize
      # have to fix this.
      
      if @post.link?
        @post.generate_screenshot
      end
      
      # if @post.text?
      #         
      #         @post.generate_screenshot
      #       end
      
      current_user.update_timestamp(:last_post_created_time)
      respond_with @post
    else
      # need to make sure create page doesn't get cleared here on an error
      respond_with(@post, :status => :precondition_failed)
    end
  end
  
  def update
    success = @post.update_attributes(params[:post])
    
    current_user.update_timestamp(:last_post_edited_time) if success
    
    respond_with @post
  end
    
  def destroy
    respond_with @post.destroy
  end
  
  def show
    respond_with @post
  end
  
  private
  
  def handle_params
    params[:post] ||= {}
    params[:post].delete(:id)
    params[:post].delete(:_id)
    params[:post].delete(:updated_at)
    params[:post].delete(:created_at)
    
    params[:post][:assets_attributes] ||= []
    @asset_params = params[:post].delete(:model_asset_ids).split(" ") if params[:post][:model_asset_ids]
    
    Post::SANITIZE.each do |k,v|
      params[:post][k] = Sanitize.clean(params[:post][k], v)
    end
    
    params[:post][:user_id] = current_user.id
  end
  
  def handle_asset_params
    params[:post] ||= {}
    params[:post][:assets] = (@post && @post.assets) ? @post.assets : []
    
    if @asset_params.present?
      @asset_params.each do |id| 
        if asset = Asset.find(id)
          params[:post][:assets] << asset
          params[:post][:asset_url] = asset.asset_image.url
          asset.set_owner(@post.id, @post.class) if @post
        end
      end  
    end
    
  end
  
end


