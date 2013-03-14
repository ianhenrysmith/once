class Asset
  include Mongoid::Document
  include Mongoid::Timestamps
  
  belongs_to :post
  belongs_to :user
  
  mount_uploader :asset_image, AssetImageUploader
  
  def self.new_from_path(path)
    file = File.new(path)
    return new_from_file(file) if file.present?
    nil
  end
  
  def self.new_from_file(file)
    asset_image = AssetImageUploader.new
    asset_image.cache!(file)
    asset = new
    asset.asset_image = asset_image
    asset
  end
  
  def self.create_from_path(path)
    asset = new_from_path(path)
    asset.save
    asset
  end
  
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