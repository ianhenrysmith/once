Once.Views.Posts ||= {}

class Once.Views.Posts.BaseView extends Backbone.View
  helpers: 
    preview: (post) =>
      switch post.type
        when "image"
          "<img src='#{post.content}' class='preview_img'>"
        when "quote"
          "<div class=preview_quote>#{post.content}</div>"
        else
          if post.content.length > 60 then post.content.substring(0,60) + "..." else post.content
    dropdown: (options={}) =>
      JST['backbone/templates/shared/dropdown'](options)