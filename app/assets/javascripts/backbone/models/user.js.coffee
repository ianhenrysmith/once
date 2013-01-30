class Once.Models.User extends Backbone.Model
  paramRoot: 'user'

  defaults:
    name: null
    email: null

class Once.Collections.UsersCollection extends Backbone.Collection
  model: Once.Models.User
  url: '/users'
