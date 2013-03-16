Once.Views.Posts ||= {}

class Once.Views.Posts.ConnectView extends Once.Views.Posts.BaseView
  events:
    "click .action": "do_action"
    "click .add_connection": "add_connection"
  template: JST["backbone/templates/posts/connect"]
    
  render_attributes:
    dropdown: true
    pane: "open"
    
  add_connection: (e) ->
    $t = $(e.target)
    console.log $t.attr("post_id")
    
  do_render: ->
    @$el.html(@template( post: @model.toJSON(), h: new Once.Helpers.PostsHelper() ))
    return this