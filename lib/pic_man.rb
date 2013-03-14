class PicMan
  def self.create_pic_for_post(post)
    url = post.url
    if url.present?
      puts "creating screencap for post #{post.id}"
      output = `phantomjs #{path} #{url} #{post.id}`
      post.add_asset(create_asset(post.id))
      return true
    end
    false
  end
  
  def self.create_asset(post_id)
    # move some of this stuff to Asset.create_from_file
    #   or Asset.create_from_path
    asset_image = AssetImageUploader.new
    asset = Asset.new
    file = File.new(file_path(post_id))
    
    asset_image.cache!(f)
    asset.asset_image = asset_image
    asset.save
    
    asset
  end
  
  private
  
  def self.path
    Rails.root.join("lib", "do_pic_man.js")
  end
  
  def self.file_path(id)
    Rails.root.join("public/uploads/tmp/#{id}_capture.png")
  end
end
