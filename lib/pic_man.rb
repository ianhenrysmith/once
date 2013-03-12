class PicMan
  def self.run(url="http://ianhenrysmith.com", post_id="smoo")
    output = `phantomjs #{path} #{url} #{post_id}`
  end
  
  def self.path
    Rails.root.join("lib", "do_pic_man.js")
  end
end
