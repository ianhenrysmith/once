class Post
  include Mongoid::Document
  include Mongoid::Timestamps
  
  TYPES = %w(quote image video link tweet text)
  
  field :content
  field :title, :type => String
  field :type
  field :description
  field :creator_avatar_url
  field :creator_name
  field :creator_path
  
  belongs_to :user
  has_many :comments
  has_many :likes
  
  validates_inclusion_of	:type, :in => TYPES
  
  def as_json(options={})
    result = super(options)
    result[:id] = id.to_s
    result[:created_string] = created_at.strftime("%D") if created_at
    result
  end
end