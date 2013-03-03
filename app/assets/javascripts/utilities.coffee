$(".dropdown_item").live("click", (e) ->
  $target = $(e.target)
  $container = $target.closest(".dropdown")
  $input = $container.find(".dropdown_target")
  
  v = $target.attr("v")
  $input.attr("value", v)
  $container.find(".dropdown-toggle").text(v)
)

$('[contenteditable]')
  .live 'focus', ->
    $this = $(this)
    $this.data 'before', $this.html()
    return $this
  .live 'blur keyup paste', ->
    $this = $(this)
    html = $this.html()
    if $this.data('before') isnt html
      index = $("[contenteditable]").index($this)
      $($(".ce_target")[index]).val(html).change()
      $this.data 'before', html
    return $this

$ ->
  $('.standard-attachment').jackUpAjax(window.jackUp) # make this only init once
  
# bind autosave forms
# should move this to a class
$(".autoupdate input").live("paste keyup change blur", () ->
  @$this = @$this || $(this)
  @$form = @$form || @$this.closest("form")
  
  @val = @$this.val()
  unless @val == @old_val
    @old_val = @val
    queue_save(@$form)
)

$(".autoupdate_btn").live("click", (e) ->
  update_form(queue_save( $(e.target).closest("form") )) )

queue_save = ($form) ->
  setup_form($form) unless $form.data("set_up") == true
    
  unless $form.data("save_queued") == true
    $form.data("save_queued", true)
    $form.find('.form_status').text("Unsaved")
    save = () -> update_form($form)
    window.setTimeout(save, 2000) #save queued
  
setup_form = ($form) ->
  $form.data("set_up", true)
  $form.append("<p class='form_status text_smaller'></p>")
  
  $form.submit( () ->
    $.ajax(
      url: $form.attr('action')
      data: $form.serialize()
      dataType: 'json'
      type: 'PUT'
      success: (json) -> 
        set_text = () -> $form.find('.form_status').text("Saved")
        window.setTimeout(set_text, 2000)
    )
    return false
  )

update_form = ($form) ->
  if typeof $form == "object" # have to fix this some time
    $form.data("save_queued", false)
    $form.find('.form_status').text("Saving...")
    $form.submit()
  