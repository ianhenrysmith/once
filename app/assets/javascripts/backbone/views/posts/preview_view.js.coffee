Once.Views.Posts ||= {}

class Once.Views.Posts.PreviewView extends Once.Views.Posts.BaseView
  events:
    "click .action": "do_action"
  template: JST["backbone/templates/posts/preview"]
    
  render_attributes:
    pane: "open"
    
  do_render: ->
    @$el.html(@template( post: @model.toJSON(), h: new Once.Helpers.PostsHelper() ))
    return this