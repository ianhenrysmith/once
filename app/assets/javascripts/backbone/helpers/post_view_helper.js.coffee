Once.Views.Posts ||= {}

class Once.Helpers.PostsHelper extends Backbone.View
  # probably want to make this Once.Views.Posts.Helper
  #   can you include helpers like modules? Does coffeescript do that?
  preview: (post) =>
    JST['backbone/templates/shared/preview'](post)
  dropdown: (options={}) =>
    JST['backbone/templates/shared/dropdown'](options)
  avatar: (url, size="medium", options={}) =>
    JST['backbone/templates/shared/avatar']({url: url, size: size, options: options})