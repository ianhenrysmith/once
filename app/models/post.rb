class Post
  include Mongoid::Document
  include Mongoid::Timestamps
  include BaseModel
  
  TYPES = %w(quote image video link tweet text)
  AJAX_ACTIONS = %w(toggle_like clear_test_posts)
  SANITIZE = {   # fields that get sanitized in PoCo#create and update
    title:       Sanitize::Config::RESTRICTED,
    content:     Sanitize::Config::RELAXED,
    description: Sanitize::Config::RELAXED
  }

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
  field :preview_url, type: String
  
  index updated_at: 1
  index user_id: 1
  
  belongs_to :user
  has_many :comments # this should probably be embedded
  has_many :assets, dependent: :destroy
  embeds_many :likes

  accepts_nested_attributes_for :assets
  
  validates_inclusion_of	:type, in: TYPES
  
  scope :recent, order_by(created_at: :desc).limit(100)
  
  def self.link_type_without_preview
    # Post.link_type_without_preview.each {|p| p.generate_screenshot}
    where(type: "link", preview_url: nil)
  end
  
  def self.test_posts
    where(user_id: "513dd113a09fc2483c000023")
  end
  
  def self.clear_test_posts
    tps = test_posts
    puts "clearing #{tps.count} test posts -------------------------"
    tps.destroy
  end
  
  def self.cache_key
    if Post.count > 0
      max_updated_at = desc(:updated_at).limit(1).only(:updated_at).first.updated_at.try(:to_i)
      Digest::MD5.hexdigest "posts_#{max_updated_at}-#{count}"
    else
      rand(19).to_s
    end
  end
  
  def self.cached(ck=cache_key, query=nil)
    Rails.cache.fetch(ck, expires: 1.hour) do
      puts 'bleh ---------------------- Post.all'
      Post.recent.to_a
    end
  end
  
  def likers_cached
    Rails.cache.fetch("post_#{id}_#{updated_at.to_i}/likers", expires: 1.week) do
      users = []
      likes.each do |like|
        users << {id: like.user_id, name: like.user_name}
      end
    end
  end
  
  def as_json(options={})
    # should also cache this based on user id, and figure out way to expire old items
    Rails.cache.fetch("post_#{id}_#{updated_at.to_i}_as_json", expires: 1.day) do
      result = super(options)
      result["id"] = id.to_s
      result["created_string"] = created_at.strftime("%m/%d/%y") if created_at
      result["tweet_embed_code"] = CGI::escape(tweet_embed_code) if tweet_embed_code
      
      if u = user
        result["creator_name"] = u.name
        result["creator_path"] = "/users/#{u.id}"
        result["creator_bb_path"] = "/#/user/#{u.id}"
        result["creator_avatar_url"] = u.asset_url
      end
      
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
      asset_image = assets.last.try(:asset_image)
      if asset_image
        self.asset_url = asset_image.url
        self.preview_url = asset_image.preview.url if asset_image.preview
      end
    end
    return save ? self.save : true
  end
  
  def toggle_like(options={})
    if user = options[:user]      
      unless likes.any{|l| l.user_id == user.id}
        user.update_timestamp(:last_post_liked_time)
        likes << Like.new(user_id: user.id, user_name: user.name)
        save
      end
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
  
  def link?
    type == "link"
  end
  
  def url
    content.strip if link?
  end
  
  def add_asset(asset, update_preview=true)
    self.assets << asset
    
    if update_preview
      self.asset_url = asset.asset_image.url
      self.preview_url = asset.asset_image.preview.url
    end
    
    self.save!
  end
  
  def generate_screenshot(job=false)
    picman = PicMan.new
    unless job
      picman.create_pic_for_post(self) if url.present? # this is a delayed jorb
    else
      picman.good_jorb(self) if url.present?
    end
  end
end