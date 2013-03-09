class Asset
  include Mongoid::Document
  include Mongoid::Timestamps
  
  belongs_to :post
  belongs_to :user
  
  mount_uploader :asset_image, AssetImageUploader
  
  def as_json(options={})
    result = super(options)
    result["id"] = id.to_s
  end
  
  def set_owner(id, klass)
    if klass == Post
      self.update_attributes(post_id: id)
    elsif klass == User
      self.update_attributes(user_id: id)
    end
  end
end