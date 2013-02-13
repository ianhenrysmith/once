Once.Views.Posts ||= {}

class Once.Views.Posts.ShowView extends Once.Views.Posts.BaseView
  template: JST["backbone/templates/posts/show"]
    
  render_attributes:
    pane: "open"
    
  do_render: ->
    @$el.html(@template( post: @model.toJSON(), h: this.helpers ))
    return this

  toggle_like: (e) =>
    $.ajax(
      url: "ajax/send_action"
      data:
        id: $("#atomic_post_id").val()
        class: "Post"
        resource_action: "toggle_like"
      dataType: "json"
      type: "POST"
    )