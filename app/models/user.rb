class User
  include Mongoid::Document

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
  
  has_many :posts
  has_many :likes
  has_many :comments
  
  validates_presence_of :email
  validates_presence_of :encrypted_password
  
  def can_create_post?(post)
    last_post_created_time == nil || !last_post_created_time.today? || Rails.env.development?
  end
  
  def update_last_post_created_time(time=Time.now)
    self.last_post_created_time = time
    self.save
  end
end
