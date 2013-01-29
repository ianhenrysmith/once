class Post
  include Mongoid::Document
  include Mongoid::Timestamps
  
  TYPES = %w(quote image video link tweet text)
  
  field :content, type: String
  field :title, type: String
  field :type, type: String
  field :description, type: String
  # user
  field :creator_avatar_url, type: String
  field :creator_name, type: String
  field :creator_path, type: String
  # twitter
  field :tweet_embed_code, type: String
  
  belongs_to :user
  has_many :comments
  has_many :likes
  
  validates_inclusion_of	:type, :in => TYPES
  
  def as_json(options={})
    result = super(options)
    result[:id] = id.to_s
    result[:created_string] = created_at.strftime("%D") if created_at
    result[:tweet_embed_code] = CGI::escapeHTML(tweet_embed_code) if tweet_embed_code
    result
  end
  
  def refresh_cache_fields
    u = user
    self.creator_name = u.name
    self.creator_path = "/users/#{u.id}"
    self.creator_avatar_url = "smoo"
    self.save
  end
  
  def set_tw_preview
    if tweet?
      code = TwitterClient.get_tw_embed_code(tweet_id)
      self.update_attributes(tweet_embed_code: code) if code.present?
    end
  end
  
  def tweet_id
    if tweet?
      content.split("status/")[1]
    end
  end
  
  def tweet?
    type == "tweet"
  end
end