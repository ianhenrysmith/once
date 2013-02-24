Once.Views.Posts ||= {}

class Once.Views.Posts.BaseView extends Backbone.View
  events:
    "click .action": "do_action"
  render_attributes:
    dropdown: false
    pane: "closed"
    upload: false
    sidebar_actions: ["like","comment"]
  permissions:
    edit: "owner"
  callbacks: []
  helpers: 
    preview: (post) =>
      JST['backbone/templates/shared/preview'](post)
    dropdown: (options={}) =>
      JST['backbone/templates/shared/dropdown'](options)
    avatar: (url, size="medium", options={}) =>
      JST['backbone/templates/shared/avatar']({url: url, size: size, options: options})
      
  toggle_pane: () =>
    @$pane = @$pane || $("#post_pane")
    pane_open = @$pane.data("open") == true
    should_open = @render_attributes.pane == "open"
    
    scroll_top = $(window).scrollTop()
    if scroll_top > 39
      @$pane.css("margin-top": "#{scroll_top}px")
    else
      @$pane.css("margin-top": "")

    if should_open && !pane_open
      @$pane.animate({
        width: "100%"
      }, 200)
      @$pane.data("open", true)
    else if !should_open && pane_open
        @$pane.animate({
          width: "0"
        }, 200)
        @$pane.data("open", false)
        
  setup_dropdowns: () ->
    $(".dropdown-toggle").dropdown()
    
  setup_upload: () ->
    $('.standard-attachment').jackUpAjax(window.jackUp)
    
  setup_edit: (post) ->
    $content_area = $(".post_content_area")
    post_type_templates = {
      image: "image"
      link:  "text"
      quote: "text"
      text:  "text"
      tweet: "text"
      video: "text"
    }
    
    set_content_area = (template="text",type="text") ->
      $content_area.html(JST["backbone/templates/posts/content_areas/edit/#{template}"]({post: post, type: type}))

    set_content_area(post_type_templates[post.get("type")], post.get("type"))

    # need to tweak the dropdown js in utilities.coffee to trigger a change event, separate these concerns
    $("#post_type_dd li").click((e) ->
      type = $(e.target).attr("v")
      set_content_area(post_type_templates[type], type)
    )
    
  render: (view) ->
    that = @do_render()
    @toggle_pane()
    @do_callbacks(@get_callbacks(), @model)
    that
    
  do_callbacks: (callbacks, post) ->
    setTimeout((setup = () => callback(post) for callback in callbacks), 1)
    
  get_callbacks: (post) ->
    callbacks=[]
    callbacks.push @setup_atomic_menu
    callbacks.push @setup_edit if @render_attributes.edit
    callbacks.push @setup_dropdowns if @render_attributes.dropdown
    callbacks.push @setup_upload if @render_attributes.upload
    callbacks
    
  setup_atomic_menu: () =>
    # could totes move this to another place I think
    # should also only do this on atomic pages
    Once.$atomic_menu = Once.$atomic_menu || $("#atomic_menu")
    unless Once.$atomic_menu.data("setup_done")
      Once.$atomic_menu.find(".acktion").click (e) => @do_action(e)
      Once.$atomic_menu.data("setup_done", true)
    # context toggle btns
    $to_show = $("")
    $to_hide = $("")
    for el in Once.$atomic_menu.find(".acktion")
      action = el.getAttribute("action")
      if $.inArray(action, @render_attributes.sidebar_actions) > -1
        permission = @permissions[action]
        permission ||= "all"
        
        if permission == "owner"
          if $("owner_id").val() == Once.Routers.PostsRouter.current_user_id
            $to_show.push el
          else
            $to_hide.push el
        else
          $to_show.push el
          
        if location = el.getAttribute("location")
          id = $("#atomic_post_id").val()
          el.setAttribute('href', location.replace(":id", id)) # /posts#/:id/edit
      else
        $to_hide.push el
    $to_show.show()
    $to_hide.hide()
    
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
    
  do_action: (e) =>
    if !e.target.getAttribute("action")
      $t = $(e.target).closest("*[action]")
    else
      $t = $(e.target)
    unless $t.attr("href") # links are for following, dawg
      action = $t.attr("action")
      this[action](e)