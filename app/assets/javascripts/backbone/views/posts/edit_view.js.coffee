Once.Views.Posts ||= {}

class Once.Views.Posts.EditView extends Once.Views.Posts.BaseView  
  template: JST["backbone/templates/posts/edit"]
  render_attributes:
    pane: "open"
    dropdown: true
    sidebar_actions: ["view", "delete"]
    edit: true
    
  events:
    "submit #edit-post": "update"
    "click .action": "do_action"

  update: (e) ->
    # should make this use autosave form
    
    e.preventDefault()
    e.stopPropagation()
    
    params = {}
    arr = $("form").serializeArray()
    for kv in arr
      params[kv.name] = kv.value

    @model.save(params,
      success: (post) =>
        @model = post
        window.location.hash = "/#{@model.id}"
      wait: true
    )

  do_render: ->
    console.log(@events)
    @$el.html(@template(post: @model.toJSON(), h: new Once.Helpers.PostsHelper() ))
    return this
