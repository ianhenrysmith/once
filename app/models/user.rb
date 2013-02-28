class User
  include Mongoid::Document
  include Mongoid::Timestamps
  include BaseModel
  
  ## Devise
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable, :validatable
  field :email,              type: String, default: ""
  field :encrypted_password, type: String, default: ""
  field :reset_password_token,   type: String
  field :reset_password_sent_at, type: Time
  field :remember_created_at, type: Time
  field :sign_in_count,      type: Integer, default: 0
  field :current_sign_in_at, type: Time
  field :last_sign_in_at,    type: Time
  field :current_sign_in_ip, type: String
  field :last_sign_in_ip,    type: String
  
  # fields
  field :name, type: String, default: "(no name)"
  
  # caching
  field :last_post_created_time, type: Time
  field :last_post_liked_time, type: Time
  
  # assets
  field :asset_url, type: String
  
  index user_id: 1
  
  has_many :assets, dependent: :destroy
  has_many :posts
  has_many :likes
  has_many :comments
  
  validates_presence_of :email
  validates_presence_of :encrypted_password
  
  def self.cache_key
    Digest::MD5.hexdigest "#{max(:updated_at).try(:to_i)}-#{count}"
  end
  
  def self.cached(ck=cache_key, query=nil)
    Rails.cache.fetch("users_#{ck}", expires: 1.week) do
      puts 'bleh ---------------------- User.all'
      User.all.to_a
    end
  end
  
  def can_create_post?(post)
    Rails.cache.fetch("user_#{id}_#{updated_at}_can_create_post", expires: 1.week) do
      last_post_created_time == nil || !last_post_created_time.today? || Rails.env.development?
    end
  end
  
  def update_last_post_created_time(time=Time.now)
    self.update_attribute( :last_post_created_time, time )
  end
  
  def update_last_post_liked_time(time=Time.now)
    self.update_attribute( :last_post_liked_time, time )
  end
  
  def refresh_cache_fields
    if assets.present?
      self.asset_url = assets.first.photo.url
    end
    self.save
  end
  
  def recent_posts
    Rails.cache.fetch("recent_user_posts_#{id}_#{last_post_created_time.to_i}", expires: 1.week) do
      Post.where(user_id: self.id).desc(:created_at).limit(100).only(:id, :title).to_a
    end
  end
  
  def recent_likes
    Rails.cache.fetch("recent_user_posts_#{id}_#{last_post_liked_time.to_i}", expires: 1.week) do
      Like.where(user_id: self.id).desc(:created_at).limit(100).only(:post_id, :post_title).to_a
    end
  end
  
  def as_json(options={})
    Rails.cache.fetch("user_#{id}_#{updated_at}_as_json", expires: 1.week) do
      result = super(options)
      result["id"] = id.to_s
      result
    end
  end
end
