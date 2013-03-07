class Like
  include Mongoid::Document
  
  belongs_to :user
  belongs_to :post
  
  field :post_title
  
  def update_cache_fields # need to update this every once in a while
    self.update_attribute( :post_title, post.title )
  end
end