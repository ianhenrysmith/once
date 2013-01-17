class Post
  include Mongoid::Document
  
  TYPES = %w(quote image video link tweet text)
  
  field :content
  field :title, :type => String
  field :type
  field :description
  
  belongs_to :user
  has_many :comments
  has_many :likes
  
  validates_inclusion_of	:type, :in => TYPES
  
  def as_json(options={})
    result = super(options)
    result[:id] = id.to_s
    result
  end
end