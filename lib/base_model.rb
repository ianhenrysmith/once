module BaseModel

  ## Plans here: 
  ##  handle multiple assets better
  def add_asset(id)
    asset = Asset.find(id)
    if asset
      self.assets << asset
      self.asset_url = asset.photo.url
      asset.set_post_id(self.id) if self.is_a? Post
    end
  end
end