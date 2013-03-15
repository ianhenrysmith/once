class Collection
  include Mongoid::Document
  include Mongoid::Timestamps
  include BaseModel
  
  field :creator_id
  
  has_many :posts
  
  
  def creator
    User.find :creator_id
  end
  
end