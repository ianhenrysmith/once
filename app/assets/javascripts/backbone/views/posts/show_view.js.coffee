Once.Views.Posts ||= {}

class Once.Views.Posts.ShowView extends Once.Views.Posts.BaseView
  template: JST["backbone/templates/posts/show"]
  render_attributes:
    pane: "open"
    
  do_render: ->
    @$el.html(@template(@model.toJSON() ))
    return this
