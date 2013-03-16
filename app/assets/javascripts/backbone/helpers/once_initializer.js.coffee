Once.Constants ||= {}

class Once.Initializer
  # yeah, yeah, this could be a singleton etc
  set_current_user: (user=false) =>
    unless Once.CurrentUser
      Once.CurrentUser = user if user
    null
    
  set_constants: (options) =>
    Once.Constants.POST_TYPES ||= options.post_types if options.post_types
    Once.Constants.COLLECTION_TYPES ||= options.collection_types if options.collection_types
    Once.Constants.CONNECTION_TYPES ||= options.connection_types if options.connection_types