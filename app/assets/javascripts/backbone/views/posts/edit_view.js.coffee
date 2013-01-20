Once.Views.Posts ||= {}

class Once.Views.Posts.EditView extends Once.Views.Posts.BaseView
  template: JST["backbone/templates/posts/edit"]

  events:
    "submit #edit-post": "update"

  update: (e) ->
    e.preventDefault()
    e.stopPropagation()
    
    params = {}
    arr = $("form").serializeArray()
    for kv in arr
      params[kv.name] = kv.value

    console.log params

    @model.save(params,
      success: (post) =>
        @model = post
        window.location.hash = "/#{@model.id}"
      wait: true
    )

  render: ->
    @$el.html(@template(post: @model.toJSON(), h: this.helpers ))
    return this
