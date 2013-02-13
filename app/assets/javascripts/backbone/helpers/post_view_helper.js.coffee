Once.Views.Posts ||= {}

class Once.Views.Posts.BaseView extends Backbone.View
  events:
    "click .action": "do_action"
  render_attributes:
    dropdown: false
    pane: "closed"
    upload: false
  helpers: 
    preview: (post) =>
      switch post.type
        when "image"
          "<img src='#{post.content}' class='preview_img'>"
        when "quote"
          "<div class=preview_quote>#{post.content}</div>"
        when "text"
          "<p>#{post.content}</p>"
        when "video"
          yt_id = post.content.split("watch?v=")[1]
          "<iframe width='270' height='152' src='http://www.youtube.com/embed/#{yt_id}' frameborder='0' allowfullscreen='true' />"
        when "tweet"
          #unescape(post.tweet_embed_code)
          "Tweet"
        else
          if post.content && post.content.length > 60
          then post.content.substring(0,60) + "..."
          else post.content
    dropdown: (options={}) =>
      JST['backbone/templates/shared/dropdown'](options)
    avatar: (url, size="medium", options={}) =>
      JST['backbone/templates/shared/avatar']({url: url, size: size, options: options})
      
  toggle_pane: () =>
    @$pane = @$pane || $("#post_pane")
    pane_open = @$pane.data("open") == true

    if @render_attributes.pane == "open" && !pane_open
      scroll_top = $(window).scrollTop()
      if scroll_top > 39
        $("#post_pane").css("margin-top": "#{scroll_top}px")
      else
        $("#post_pane").css("margin-top": "")
      @$pane.animate({
        width: "100%"
      }, 200)
      @$pane.data("open", true)
    else
      if pane_open
        @$pane.animate({
          width: "0"
        }, 200)
        @$pane.data("open", false)
        
  setup_dropdowns: () ->
    $(".dropdown-toggle").dropdown()
    
  setup_upload: () ->
    $('.standard-attachment').jackUpAjax(window.jackUp)
    
  render: (view) ->
    that = @do_render()
    @toggle_pane()
    @do_callbacks(@get_callbacks())
    that
    
  do_callbacks: (callbacks) ->
    setTimeout((setup = () => callback() for callback in callbacks), 1)
    
  get_callbacks: (callbacks=[]) ->
    callbacks.push @setup_outside_actions
    callbacks.push @setup_dropdowns if @render_attributes.dropdown
    callbacks.push @setup_upload if @render_attributes.upload
    callbacks
    
  setup_outside_actions: () =>
    # could totes move this to another place I think
    Once.$atomic_menu = Once.$atomic_menu || $("#atomic_menu")
    unless Once.$atomic_menu.data("setup_done")
      Once.$atomic_menu.find(".acktion").click (e) => @do_action(e)
      Once.$atomic_menu.data("setup_done", true)
      
  do_action: (e) =>
    console.log this
    action = $(e.target).attr("action")
    this[action](e)