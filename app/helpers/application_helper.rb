module ApplicationHelper
  
  def bb_path(options)
    if options[:resource]
      "/#/#{options[:resource].id}"
    elsif options[:id]
      "/#/#{options[:id]}"
    end
  end
end
