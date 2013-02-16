class User
  include Mongoid::Document
  include Mongoid::Timestamps
  
  ## Devise
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable, :validatable
  field :email,              :type => String, :default => ""
  field :encrypted_password, :type => String, :default => ""
  field :reset_password_token,   :type => String
  field :reset_password_sent_at, :type => Time
  field :remember_created_at, :type => Time
  field :sign_in_count,      :type => Integer, :default => 0
  field :current_sign_in_at, :type => Time
  field :last_sign_in_at,    :type => Time
  field :current_sign_in_ip, :type => String
  field :last_sign_in_ip,    :type => String
  
  # fields
  field :name, :type => String, :default => ""
  field :last_post_created_time, :type => Time
  # assets
  field :asset_url, type: String
  
  has_many :assets, dependent: :destroy
  has_many :posts
  has_many :likes
  has_many :comments
  
  validates_presence_of :email
  validates_presence_of :encrypted_password
  
  def self.cache_key
    Digest::MD5.hexdigest "#{maximum(:updated_at)}.try(:to_i)-#{count}"
  end
  
  def can_create_post?(post)
    last_post_created_time == nil || !last_post_created_time.today? || Rails.env.development?
  end
  
  def update_last_post_created_time(time=Time.now)
    self.last_post_created_time = time
    self.save
  end
  
  def refresh_cache_fields
    if assets.present?
      self.asset_url = assets.first.photo.url
    end
    self.save
  end
  
  def recent_post_ids
    Rails.cache.fetch("recent_user_posts_#{id}_#{last_post_created_time.to_i}") do
      posts = Post.where(user_id: self.id).desc(:created_at).limit(100).only(:id).to_a.map{ |p| p.id }
      
    end
  end
  
  def as_json(options={})
    result = super(options)
    result["id"] = id.to_s
    result
  end
end
