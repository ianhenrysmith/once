Once.Views.Posts ||= {}

class Once.Views.Posts.IndexView extends Once.Views.Posts.BaseView
  template: JST["backbone/templates/posts/index"]

  initialize: () ->
    @options.posts.bind('reset', @addAll)

  addAll: () =>
    @options.posts.each(@addOne)

  addOne: (post) =>
    view = new Once.Views.Posts.PostView({model : post})
    @$("#posts_body").append(view.render().el)
    
  filter_posts: (e) =>
    current_user_id = $("#current_user_id").val()
    posts = new Once.Collections.PostsCollection(@options.posts.where({user_id: current_user_id}))
    @render(posts)
    
  do_render: (posts=@options.posts.toJSON()) ->
    # only need to render if pageload or coming from another view
    #   should fix this!
    if @options.user then user = @options.user.toJSON() else user = {}
    @$el.html(@template(posts: posts, h: @helpers, user: user))
    @addAll()

    return this
