Once.Views.Posts ||= {}

class Once.Views.Posts.IndexView extends Backbone.View
  template: JST["backbone/templates/posts/index"]
  
  events:
    "click .view_action": "do_action"

  initialize: () ->
    @options.posts.bind('reset', @addAll)

  addAll: () =>
    @options.posts.each(@addOne)

  addOne: (post) =>
    view = new Once.Views.Posts.PostView({model : post})
    @$("tbody").append(view.render().el)
    
  do_action: (e) =>
    action = $(e.target).attr("action")
    this[action]()
    
  filter_posts: () =>
    current_user_id = $("#current_user_id").val()
    # @options.posts
    posts = @options.posts.filter( (post) -> post.get("user_id") == current_user_id )
    @options.posts = posts
    
  render: =>
    @$el.html(@template(posts: @options.posts.toJSON() ))
    @addAll()

    return this
