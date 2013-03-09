class Like
  include Mongoid::Document
  
  belongs_to :user
  belongs_to :post
    
  def self.user_likes
    # make this a mongoid scope
  end
  
  def update_cache_fields # need to update this every once in a while
    self.update_attribute( :post_title, post.title )
  end
  
  def post_title
    Rails.cache.fetch("like_#{id}/post_title", expires: 1.day) do
      puts "post title for like #{id}"
      post.title if post = Post.where(id: post_id).only(:title).first
    end
  end
end