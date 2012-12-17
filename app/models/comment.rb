class Comment
  include Mongoid::Document
  include Mongoid::Timestamps
  
  field :body
  field :thread, :type => String
  
  belongs_to :user
  belongs_to :post
end