module ApplicationHelper
  
  def bb_path(resource, action=nil)
    "/#{resource.class.to_s.downcase.pluralize}#/#{resource.id}"
  end
end
