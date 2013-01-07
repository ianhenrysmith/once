class Once.Routers.PostsRouter extends Backbone.Router
  initialize: (options) ->
    @current_user_id = $("#current_user_id").val()
    @smoo = "smoo"
    @posts = new Once.Collections.PostsCollection()
    @posts.fetch()
    @posts.reset options.posts

  routes:
    "new"      : "newPost"
    "index"    : "index"
    ":id/edit" : "edit"
    ":id"      : "show"
    ".*"       : "index"

  newPost: ->
    @view = new Once.Views.Posts.NewView(collection: @posts)
    $("#posts").html(@view.render().el)

  index: ->
    @view = new Once.Views.Posts.IndexView(posts: @posts)
    $("#posts").html(@view.render().el)

  show: (id) ->
    post = @posts.get(id)
    @view = new Once.Views.Posts.ShowView(model: post)
    $("#posts").html(@view.render().el)

  edit: (id) ->
    post = @posts.get(id)
    
    @view = new Once.Views.Posts.EditView(model: post)
    $("#posts").html(@view.render().el)
