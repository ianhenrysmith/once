Once.Views.Posts ||= {}

class Once.Views.Posts.NewView extends Once.Views.Posts.BaseView
  template: JST["backbone/templates/posts/new"]
  render_attributes:
    pane: "open"
    dropdown: true
    upload: true
    edit: true
    
  events:
    "submit #new-post": "save"

  constructor: (options) ->
    super(options)
    @model = new @collection.model()

    @model.bind("change:errors", () =>
      this.render()
    )

  save: (e) ->
    e.preventDefault()
    e.stopPropagation()

    @model.unset("errors")
    
    params = {}
    arr = $("form").serializeArray()
    for kv in arr
      params[kv.name] = kv.value

    @collection.create(params,
      wait: true
      success: (post) =>
        window.CanCreate = false
        @model = post
        window.location.hash = "/#{@model.id}"

      error: (post, jqXHR) =>
        @model.set({errors: $.parseJSON(jqXHR.responseText)})
    )

  do_render: () ->
    @$el.html(@template(post: @model.toJSON(), h: @helpers  ))
    return this