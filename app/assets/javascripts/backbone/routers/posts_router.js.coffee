class Once.Routers.PostsRouter extends Backbone.Router
  initialize: (options) ->
    @current_user_id = $("#current_user_id").val()
    @posts = new Once.Collections.PostsCollection()
    @posts.reset options.posts
    
    @$pane = $("#post_pane")
    @$post = $("#post_pane_content")
    @$posts = $("#posts")
    
  routes:
    "new"      : "newPost"
    "index"    : "index"
    ":id/edit" : "edit"
    ":id"      : "show"
    ".*"       : "index"

  newPost: ->
    @view = new Once.Views.Posts.NewView(collection: @posts)
    @$post.html(@view.render().el)
    @$pane.animate({
      width: "100%"
    }, 200)
    
  index: ->
    @view = new Once.Views.Posts.IndexView(posts: @posts)
    @$posts.html(@view.render().el)
    @$pane.animate({
      width: "0"
    }, 200)

  show: (id) ->
    post = @posts.get(id)
    @view = new Once.Views.Posts.ShowView(model: post)
    @$post.html(@view.render().el)
    
    # should move this to an elightened plane
    @$pane.animate({
      width: "100%"
    }, 200)

  edit: (id) ->
    post = @posts.get(id)
    @view = new Once.Views.Posts.EditView(model: post)
    @$post.html(@view.render().el)
    @$pane.animate({
      width: "100%"
    }, 200)
    
    # this too
    $(".dropdown-toggle").dropdown()
    