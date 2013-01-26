class Post
  include Mongoid::Document
  include Mongoid::Timestamps
  
  TYPES = %w(quote image video link tweet text)
  
  field :content, :type => String
  field :title, :type => String
  field :type, :type => String
  field :description, :type => String
  # user
  field :creator_avatar_url, :type => String
  field :creator_name, :type => String
  field :creator_path, :type => String
  
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
  
  def refresh_cache_fields
    u = user
    self.creator_name = u.name
    self.creator_path = "/users/#{u.id}"
    self.creator_avatar_url = "smoo"
    self.save
  end
end