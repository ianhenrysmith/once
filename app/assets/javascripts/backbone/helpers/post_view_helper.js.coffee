Once.Views.Posts ||= {}

class Once.Helpers.PostsHelper extends Backbone.View
  # Can you include helpers like modules? Does coffeescript do that?
  preview: (post) =>
    @partial('shared/preview', post)
    
  dropdown: (options={}) =>
    @partial('shared/dropdown', options)
    
  avatar: (url, size="medium", options={}) =>
    @partial('shared/avatar', { url: url, size: size, options: options })
    
  partial: (path, options={}) =>
    # would love to have a fallback option here, if partial doesn't exist.
    #   that would make it easier to add post types on the fly
    JST["backbone/templates/#{path}"](options)
    
  augment_with_user_params: (obj={}) =>
    user = @current_user()
    new_obj = Object.create(obj);
    new_obj.user_id = user.id
    new_obj.creator_name = user.name
    new_obj.creator_path = "/users/#{user.id}"
    new_obj.creator_avatar_url = user.asset_url
    new_obj
    
  current_user: () =>
    Once.CurrentUser
    
  add_liked_post_id: (post_id) =>
    @current_user().liked_post_ids.push(post_id)
    
  # this and check_post_create should probably go in baseview
  post_created: (date) =>
    @current_user().last_post_created_time = date
  
  can_create: () =>
    if current_user = @current_user()
      created_date = new Date(current_user.last_post_created_time)
      now = new Date()
      
      return true if current_user.email == "ian@kapost.com"

      if created_date.getDate() == now.getDate()
        if created_date.getMonth() == now.getMonth()
          if created_date.getFullYear() == now.getFullYear()
            return false
      return true
    return false