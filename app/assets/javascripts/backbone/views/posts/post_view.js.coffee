Once.Views.Posts ||= {}

class Once.Views.Posts.PostView extends Once.Views.Posts.BaseView
  template: JST["backbone/templates/posts/post"]

  events:
    "click .destroy" : "destroy"

  tagName: "div"
  className: "post_block"
    
  destroy: () ->
    @model.destroy()
    this.remove()

    return false

  render: ->
    @$el.html(@template(post: @model.toJSON(), h: this.helpers ))
    return this
