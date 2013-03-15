class Like
  include Mongoid::Document
  
  belongs_to :user
  belongs_to :post
    
  def self.user_likes
    # make this a mongoid scope
  end
  
  def post_title
    Rails.cache.fetch("like_#{id}/post_title", expires: 1.day) do
      # argh should be a scope
      post.title if post = Post.where(id: post_id).only(:title).first
    end
  end
end