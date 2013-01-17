class Once.Models.Post extends Backbone.Model
  paramRoot: 'post'

  defaults:
    title: null
    content: null
    type: "text"

class Once.Collections.PostsCollection extends Backbone.Collection
  model: Once.Models.Post
  url: '/posts'
