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
    "click .action": "do_action"

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
    
    # move to utility?
    arr = $("form").serializeArray()
    for kv in arr
      params[kv.name] = kv.value
      
    post_params = @h().augment_with_user_params(params)

    @collection.create(post_params,
      wait: true
      success: (post) =>
        @h().post_created(new Date())
        @model = post
        window.location.hash = "/#{@model.id}"

      error: (post, jqXHR) =>
        @model.set({errors: $.parseJSON(jqXHR.responseText)})
    )

  do_render: () ->
    @$el.html(@template(post: @model.toJSON(), h: @h() ))
    return this