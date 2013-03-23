class Like
  include Mongoid::Document
  
  field :user_id
  field :user_name
  
  embedded_in :post
    
  def self.user_likes
    # make this a mongoid scope
  end
  
  def self.users_for_post_id(post_id)
    user_ids = where(post_id: post_id).only(:user_id).to_a.map(&:user_id)
    User.where(:id.in => user_ids)
  end
  
  def post_title
    post.title
  end
  
  def user
    if u = User.find(user_id)
      self.update_attribute(:user_name, u.name) if user_name != u.name
      u
    end
  end
end