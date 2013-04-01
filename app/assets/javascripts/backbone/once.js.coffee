#= require_self
#= require_tree ./templates
#= require_tree ./models
#= require_tree ./helpers
#= require_tree ./views
#= require_tree ./routers

window.Once ||= {}

Once.Models = {}
Once.Collections = {}
Once.Routers = {}
Once.Views = {}
Once.Helpers = {}
Once.Constants = {}
  
Once.Constants.CanCreate = true