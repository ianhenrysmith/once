class Connection
  include Mongoid::Document
  include Mongoid::Timestamps
  include BaseModel
  
  TYPES = ["was inspired by", "is like", "has same creator as"]
  #   <product> <connection> <source>
  
  
  field :source_post_id
  field :product_post_id
  
  field :connection_type
  
  field :how_connected # creator's note about how posts relate to each other
  
  # made me think of how jackson pollock was a propagandist (sp?)
  # is also like this other post about enzo ferrari
  # this site was designed by the same guy as ministryoftype
  
  belongs_to :user
end