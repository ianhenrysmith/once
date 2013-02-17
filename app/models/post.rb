class Post
  include Mongoid::Document
  include Mongoid::Timestamps
  include BaseModel
  
  TYPES = %w(quote image video link tweet text)
  AJAX_ACTIONS = %w(toggle_like)

  field :content, type: String
  field :title, type: String, default: "(untitled)"
  field :type, type: String, default: "text"
  field :description, type: String
  # user
  field :creator_avatar_url, type: String
  field :creator_name, type: String
  field :creator_path, type: String
  # twitter
  field :tweet_embed_code, type: String
  field :assets_attributes
  # assets
  field :asset_url, type: String
  
  belongs_to :user
  has_many :comments
  has_many :likes
  has_many :assets, dependent: :destroy

  accepts_nested_attributes_for :assets
  
  validates_inclusion_of	:type, in: TYPES
  
  def self.cache_key
    Digest::MD5.hexdigest "#{max(:updated_at).try(:to_i)}-#{count}"
  end
  
  def self.cached(ck=cache_key, query=nil)
    Rails.cache.fetch("posts_#{ck}") do
      puts 'bleh ---------------------- Post.all'
      Post.all.to_a
    end
  end
  
  def as_json(options={})
    Rails.cache.fetch("post_#{id}_#{updated_at}_as_json", expires: 1.week) do
      result = super(options)
      result["id"] = id.to_s
      result["created_string"] = created_at.strftime("%D") if created_at
      result["tweet_embed_code"] = CGI::escape(tweet_embed_code) if tweet_embed_code
    
      result
    end
  end
  
  def refresh_cache_fields(save=false)
    if u = user
      self.creator_name = u.name
      self.creator_path = "/users/#{u.id}"
      self.creator_avatar_url = u.asset_url
    end
    if assets.present?
      self.asset_url = assets.first.photo.url
    end
    return save ? self.save : true
  end
  
  def toggle_like(options={})
    if user = options[:user]
      # should probably send over like id, if possible, for faster find
      action = "destroy" if like = Like.where(post_id: id, user_id: user.id).first
      like ||= Like.new(post: self, user: user)
      like.try{|l| l.send( action ||= "save" )} == true
    end
  end
  
  # twitter
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