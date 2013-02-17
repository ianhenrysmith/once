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
    current_user_id = Once.Routers.PostsRouter.current_user_id
    posts = new Once.Collections.PostsCollection(@options.posts.where({user_id: current_user_id}))
    @render(posts)
    
  do_render: (posts=@options.posts.toJSON()) ->
    # only need to render if pageload or coming from another view
    #   should fix this!
    @$el.html(@template(posts: posts, h: @helpers, user: @options.user))
    @addAll()

    return this
