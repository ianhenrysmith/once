class Asset
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Paperclip

  attr_accessor :image_file_name, :image_content_type, :image_file_size, :image_updated_at
  
  belongs_to :post
  belongs_to :user
  
  has_mongoid_attached_file :photo,
    path:          ':id/:style.:extension',
    storage:        :s3,
    s3_credentials: {
      bucket:            ENV['AWS_BUCKET'],
      access_key_id:     ENV['AWS_ACCESS_KEY_ID'],
      secret_access_key: ENV['AWS_SECRET_ACCESS_KEY']
    }
    #, styles: {
    #  thumb: '100x100>',
    #  square: '200x200#',
    #  medium: '300x300>'
    #}
    
  # to show asset:
  #   <%= @asset.photo.url %>
  
  attr_accessible :photo
  
  def as_json(options={})
    result = super(options)
    result["id"] = id.to_s
  end
  
  def set_post_id(id)
    self.update_attributes(post_id: id)
  end
end