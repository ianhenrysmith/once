class Post
  include Mongoid::Document
  
  TYPES = %w(quote image video link tweet)
  
  field :content
  field :title, :type => String
  field :type
  
  belongs_to :user
  has_many :comments
  has_many :likes
  
  validates_inclusion_of	:type, :in => TYPES
end