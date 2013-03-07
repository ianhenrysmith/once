Once.Views.Posts ||= {}

class Once.Helpers.PostsHelper extends Backbone.View
  # Can you include helpers like modules? Does coffeescript do that?
  preview: (post) =>
    @partial('shared/preview', post)
  dropdown: (options={}) =>
    @partial('shared/dropdown', options)
  avatar: (url, size="medium", options={}) =>
    @partial('shared/avatar', { url: url, size: size, options: options })
  partial: (path, options) =>
    # would love to have a fallback option here, if partial doesn't exist.
    #   that would make it easier to add post types on the fly
    JST["backbone/templates/#{path}"](options)