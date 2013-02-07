class Asset
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Paperclip

  attr_accessor :image_file_name, :image_content_type, :image_file_size, :image_updated_at
  
  belongs_to :post
  belongs_to :user
  has_mongoid_attached_file :photo
  attr_accessible :photo
  
  def as_json(options={})
    result = super(options)
    result["id"] = id.to_s
  end
end