class Once.Routers.PostsRouter extends Backbone.Router
  initialize: (options) ->
    @current_user_id = $("#current_user_id").val()
    @posts = new Once.Collections.PostsCollection()
    @posts.reset options.posts
    @users = new Once.Collections.UsersCollection()
    @users.reset options.users
    
    @$pane = $("#post_pane")
    @$post = $("#post_pane_content")
    @$posts = $("#posts")
    
  routes:
    "new"           : "newPost"
    "index"         : "index"
    ":id/edit"      : "edit"
    ":id"           : "show"
    ".*"            : "index"
    "user/:user_id" : "user_index"

  newPost: ->
    @view = new Once.Views.Posts.NewView(collection: @posts)
    @$post.html(@view.render().el)
    @$pane.animate({
      width: "100%"
    }, 200)
    $(".dropdown-toggle").dropdown()
    $('.standard-attachment').jackUpAjax(window.jackUp)
    
  index: ->
    @view = new Once.Views.Posts.IndexView(posts: @posts)
    @$posts.html(@view.render().el)
    @$pane.animate({
      width: "0"
    }, 200)
    
  user_index: (user_id) ->
    # http://localhost:9191/posts#/user/50cf3be9a09fc2ac83000001
    
    @user = @users.get(user_id)
    if @user
      posts = new Once.Collections.PostsCollection( @posts.where({user_id: user_id}) )
    else
      posts = @posts
      
    @view = new Once.Views.Posts.IndexView(posts: posts, user: @user)
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
    