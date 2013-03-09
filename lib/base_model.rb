module BaseModel

  ## Plans here: 
  ##  handle multiple assets better
  def add_asset(id)
    asset = Asset.find(id)
    if asset
      self.assets << asset
      self.asset_url = asset.asset_image.url
      asset.set_owner(self.id, self.class)
    end
  end
end