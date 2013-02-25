Once.Views.Posts ||= {}

class Once.Views.Posts.ShowView extends Once.Views.Posts.BaseView
  template: JST["backbone/templates/posts/show"]
    
  render_attributes:
    pane: "open"
    sidebar_actions: [
      "toggle_like",
      "comment",
      "edit",
      "delete"
      ]
    
  do_render: ->
    @$el.html(@template( post: @model.toJSON(), h: this.helpers ))
    return this