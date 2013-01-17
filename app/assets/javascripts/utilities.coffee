$(".dropdown_item").live("click", (e) ->
  $target = $(e.target)
  $container = $target.closest(".dropdown")
  $input = $container.find(".dropdown_target")
  
  v = $target.attr("v")
  $input.attr("value", v)
  $container.find(".dropdown-toggle").text(v)
)