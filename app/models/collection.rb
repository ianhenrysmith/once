class Collection
  include Mongoid::Document
  include Mongoid::Timestamps
  include BaseModel
  
  TYPES = ["other", "theme"]
  
  field :creator_id
  field :description
  
  has_many :posts
  
  def creator
    User.find :creator_id
  end
  
end