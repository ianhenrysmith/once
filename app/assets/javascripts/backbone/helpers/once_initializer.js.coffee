Once.Constants ||= {}

class Once.Initializer
  # yeah, yeah, this could be a singleton etc
  set_current_user: (user=false) =>
    unless Once.CurrentUser
      Once.CurrentUser = user if user
    null
    
  set_post_types: (post_types) =>
    unless Once.POST_TYPES
      Once.Constants.POST_TYPES = post_types
    null