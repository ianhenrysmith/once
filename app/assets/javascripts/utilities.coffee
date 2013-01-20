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
            $this.data 'before', html
            console.log html
            $this.trigger('change')
        return $this