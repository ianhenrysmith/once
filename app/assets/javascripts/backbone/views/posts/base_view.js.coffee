Once.Views.Posts ||= {}

class Once.Views.Posts.BaseView extends Backbone.View
  events:
    "click .action": "do_action"
  render_attributes:
    dropdown: false
    pane: "closed"
    upload: false
  permissions:
    delete: "owner"
    edit: "owner"
  callbacks: []
  
  h: () =>
    @helper ||= new Once.Helpers.PostsHelper()
    
  toggle_pane: () =>
    @$pane ||= $("#post_pane")
    @$index ||= $("#posts")
        
    should_open = @render_attributes.pane == "open"
    @$w ||= $(window)

    if should_open
      @set_scroll()
      
      @$pane.show()
      @$index.hide()
      
      @$pane.data("open", true)
      @scroll_to(0)
    else
      @$pane.hide(0, () =>
        @scroll_to(@get_scroll())
      )
      @$index.show()      
      @$pane.data("open", false)
      
  set_scroll: () =>
    Once.Constants.Scroll = @$w.scrollTop()
    
  get_scroll: () =>
    Once.Constants.Scroll
    
  scroll_to: (height) =>
    @$w.scrollTop(height) if typeof(height) == "number"
  
  setup_dropdowns: () =>
    $(".dropdown-toggle").dropdown()
    
  setup_upload: () =>
    $('.standard-attachment').jackUpAjax(window.jackUp)
    
  setup_edit: () =>
    @$content_area ||= $(".post_content_area")
    @post_type_templates ||= {
      image: "image"
      link:  "text"
      quote: "text"
      text:  "text"
      tweet: "text"
      video: "text"
    }
    
    set_content_area = (template="text",type="text") =>
      html = new @h().partial("posts/content_areas/edit/#{template}", {post: @model, type: type})
      @$content_area.html(html)
      if type == "image"
        @setup_upload()

    set_content_area(@post_type_templates[@model.get("type")], @model.get("type"))

    # need to tweak the dropdown js in utilities.coffee to trigger a change event, separate these concerns
    $("#post_type_dd li").click((e) =>
      type = $(e.target).attr("v")
      set_content_area(@post_type_templates[type], type)
    )
    
  check_post_create: () =>
    unless @h().can_create()
      $("#create_btn").addClass("inactive").attr("href", "javascript://")
    else
      $("#create_btn").removeClass("inactive").attr("href", "/#/new")
    
  render: (view) ->
    that = @do_render()
    @toggle_pane()
    @do_callbacks(@get_callbacks(), @model)
    that
  
  do_callbacks: (callbacks, post) ->
    setTimeout((setup = () => callback(post) for callback in callbacks), 1)
    
  get_callbacks: (post) ->
    callbacks=[]
    callbacks.push @check_post_create
    callbacks.push @setup_edit if @render_attributes.edit
    callbacks.push @setup_dropdowns if @render_attributes.dropdown
    callbacks.push @setup_upload if @render_attributes.upload
    callbacks
    
  toggle_like: (e, $t) =>
    @h().add_liked_post_id(@model.id)
    
    $.ajax(
      url: "ajax/send_action"
      data:
        id: @model.id
        class: "Post"
        resource_action: "toggle_like"
      dataType: "json"
      type: "POST"
      success: () ->
        $t.removeClass("action").addClass("liked").text("LIKED");
    )
    
  do_action: (e) =>
    if !e.target.getAttribute("action")
      $t = $(e.target).closest("*[action]")
    else
      $t = $(e.target)
    unless $t.attr("href") # links are for following, dawg
      action = $t.attr("action")
      if action
        # want to set post id etc
        this[action](e, $t)
      else
        console.log "make sure to set the action attr of this element"
      
      