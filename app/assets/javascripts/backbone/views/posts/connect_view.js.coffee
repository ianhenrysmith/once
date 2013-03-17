Once.Views.Posts ||= {}

class Once.Views.Posts.ConnectView extends Once.Views.Posts.BaseView
  events:
    "click .action": "do_action"
    "click .post_title": "lock_preview"
    "mouseover .post_title": "preview_post"
    "click .unlock_btn": "unlock_preview"
    "click .create_connection_btn": "create_connection"
  template: JST["backbone/templates/posts/connect"]
    
  render_attributes:
    dropdown: true
    pane: "open"
    
  create_connection: (e) =>
    connection_type = $("#type").val()
    connection = {
      source_post_id: @model.get("id")
      product_post_id: @current_post.get("id")
      connection_type: connection_type
    }
    
    $.post("connections", { connection }, () =>
      @$(".connection_created").show();
      @$(".created_connections").append("<p>#{@model.get("title")} #{connection_type} <a href='/#/#{@current_post.get('id')}' class='vanilla'>#{@current_post.get("title")}</a></p>")
      @unlock_preview()
    )
    
  lock_preview: (e) =>
    @locked = true
    @set_current_post(e)
    @$(".unlock_btn, .create_connection_btn").show()
    @$(".connection_created").hide()
    
  unlock_preview: () =>
    @locked = false
    @$(".product_preview").html("")
    @$(".unlock_btn, .create_connection_btn").hide()
    @$(".product_post_title").text("(no post selected)")
    
  preview_post: (e) =>
    unless @locked
      @set_current_post(e)
    
  set_current_post: (e) =>
    $t = $(e.target)
    @current_post = @h().current_user().recent_posts.where({id: $t.attr("post_id")})[0]
    prod_view = new Once.Views.Posts.PostView({model : @current_post})
    @$(".product_preview").html(prod_view.render().el)
    @$(".product_post_title").text(@current_post.get("title"))
    
  do_render: =>
    @$el.html(@template( post: @model.toJSON(), h: new Once.Helpers.PostsHelper() ))
    
    src_view = new Once.Views.Posts.PostView({model : @model})
    @$(".src_preview").html(src_view.render().el)
    
    return this