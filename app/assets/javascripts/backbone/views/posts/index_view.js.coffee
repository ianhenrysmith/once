Once.Views.Posts ||= {}

class Once.Views.Posts.IndexView extends Once.Views.Posts.BaseView
  template: JST["backbone/templates/posts/index"]
  
  events:
    "click .view_action": "do_action"

  initialize: () ->
    @options.posts.bind('reset', @addAll)

  addAll: () =>
    @options.posts.each(@addOne)

  addOne: (post) =>
    view = new Once.Views.Posts.PostView({model : post})
    @$("#posts_body").append(view.render().el)
    
  do_action: (e) =>
    action = $(e.target).attr("action")
    this[action](e)
    
  filter_posts: (e) =>
    current_user_id = $("#current_user_id").val()
    posts = new Once.Collections.PostsCollection(@options.posts.where({user_id: current_user_id}))
    @render(posts)
    
  render: (posts=@options.posts.toJSON()) =>
    if @options.user then user = @options.user.toJSON() else user = {}
    @$el.html(@template(posts: posts, h: this.helpers, user: user))
    @addAll()

    return this
