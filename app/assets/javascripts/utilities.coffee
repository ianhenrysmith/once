window.Once ||= {}

$(".dropdown_item").live("click", (e) ->
  $target = $(e.target)
  $container = $target.closest(".dropdown")
  $input = $container.find(".dropdown_target")
  
  v = $target.attr("v")
  $input.attr("value", v)
  $container.find(".dropdown-toggle").text(v)
)

class ContentEditableFridge
  constructor: () ->
    @editors = []
    @init()
    
  init: () =>
    $ce = $('[contenteditable]')
    $ce.live 'blur change focus keyup paste', (e) =>
      @get_editor($(e.target)).update_data()
        
  get_editor: ($el) =>
    if !$el.data("editor_setup")
      editor = new Editor($el, @editors.length)
      @editors.push( editor )
    else
      editor = @editors[$el.data("editor_index")]
    editor

class Editor
  # to implement:
  #     get, save selection on keyup/mouseup
  constructor: ($el, editor_index) ->
    @$el = $el
    @$el.data("editor_setup", true)
    @$el.data("editor_index", editor_index)
    
    @editor_index = editor_index
    @before = ""
    
    index = $("[contenteditable]").index(@$el)
    @$data_target = $(".ce_target").eq(index)
    
    @insert_enabled = @$el.hasClass('insert_link_target')
    if @insert_enabled
      @setup_insert()
    
  setup_insert: () =>
    insert_index = $(".insert_link_target").index(@$el)
    
    @$insert_container = $(".insert_container").eq(insert_index)
    @$insert_field = @$insert_container.find(".insert_link_field")
    @$insert_btn = @$insert_container.find(".insert_link")
    @$insert_flash = @$insert_container.find(".insert_flash")
    
    @$el.bind "mouseup keyup", () =>
      @update_selection()
    @$insert_btn.bind "click", () =>
      @insert_selection()
    
    @$insert_container.slideDown()

  update_data: () =>
    html = @$el.html()
    if @before isnt html
      @$data_target.val(html).change()
      @before = html
      
  update_selection: () =>
    selection_temp = window.getSelection()
    if $(selection_temp.baseNode.parentNode).data("editor_index") == @editor_index
      @range = selection_temp.getRangeAt(0)
      @selection = new Object(selection_temp)
      window.Smoo = window.getSelection()
      @selected_text = selection_temp.toString()
    
  insert_selection: () =>
    if @selected_text.length
      location = @$insert_field.val()
      
      new_element = document.createElement('a')
      new_element.innerHTML = @selected_text
      new_element.href = location
      new_element.target = "_blank"

      @range.deleteContents();
      @range.insertNode(new_element)
      @$insert_field.val("")
      @$el.change()
      @set_flash("Link inserted.")
    else
      @set_flash("Select some text first.")
  set_flash: (message) =>
    @$insert_flash.text(message).show()
    fn = () =>
      @$insert_flash.hide()
    setTimeout(fn, 5000)
    
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
  
Once.content_editable_fridge = new ContentEditableFridge()