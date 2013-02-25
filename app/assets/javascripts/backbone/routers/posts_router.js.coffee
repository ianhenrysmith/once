class Once.Routers.PostsRouter extends Backbone.Router
  initialize: (options) ->
    @current_user_id = $("#current_user_id").val()
    @posts = new Once.Collections.PostsCollection()
    @posts.reset options.posts
    
    @$post = $("#post_pane_content")
    @$posts = $("#posts")
    
  routes:
    "new"           : "newPost"
    "index"         : "index"
    ":id/edit"      : "edit"
    ":id"           : "show"
    ".*"            : "index"
    "user/:user_id" : "user_index"
    ""              : "index"

  newPost: ->
    @view = new Once.Views.Posts.NewView(collection: @posts)
    @$post.html(@view.render().el)
    
  index: ->
    @view = new Once.Views.Posts.IndexView(posts: @posts)
    @$posts.html(@view.render().el)
    
  user_index: (user_id) ->
    posts = new Once.Collections.PostsCollection( @posts.where({user_id: user_id}) )

    post = posts.at(0)
    user = {
      name:      post.get("creator_name")
      asset_url: post.get("creator_avatar_url")
      id:        post.get("user_id")
    }
    @view = new Once.Views.Posts.IndexView(posts: posts, user: user)
    @$posts.html(@view.render().el)

  show: (id) ->
    post = @posts.get(id)
    @view = new Once.Views.Posts.ShowView(model: post)
    @$post.html(@view.render().el)

  edit: (id) ->
    post = @posts.get(id)
    @view = new Once.Views.Posts.EditView(model: post)
    @$post.html(@view.render().el)
    