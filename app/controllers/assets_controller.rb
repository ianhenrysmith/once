class AssetsController < ApplicationController
  respond_to :json, :html
  
  def create
    debugger
    
    @asset = Asset.new(photo: params[:file])

    if @asset.save
      respond_with @asset
    else
      head :bad_request
    end
  end
end