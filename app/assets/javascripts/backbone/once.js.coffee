#= require_self
#= require_tree ./templates
#= require_tree ./models
#= require_tree ./helpers
#= require_tree ./views
#= require_tree ./routers

window.Once =
  Models: {}
  Collections: {}
  Routers: {}
  Views: {}
  Helpers: {}
  Constants: {}
  
Once.Constants.CanCreate = true