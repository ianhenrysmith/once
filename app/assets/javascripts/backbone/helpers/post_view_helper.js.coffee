Once.Views.Posts ||= {}

class Once.Views.Posts.BaseView extends Backbone.View
  helpers: 
    preview: (post) =>
      switch post.type
        when "image"
          "<img src='#{post.content}' class='preview_img'>"
        when "quote"
          "<div class=preview_quote>#{post.content}</div>"
        when "text"
          "<p>#{post.content}</p>"
        when "video"
          yt_id = post.content.split("watch?v=")[1]
          "<iframe width='270' height='152' src='http://www.youtube.com/embed/#{yt_id}' frameborder='0' allowfullscreen='true' />"
        when "tweet"
          #unescape(post.tweet_embed_code)
          "Tweet"
        else
          if post.content && post.content.length > 60
          then post.content.substring(0,60) + "..."
          else post.content
    dropdown: (options={}) =>
      JST['backbone/templates/shared/dropdown'](options)
    avatar: (url, size="medium", options={}) =>
      JST['backbone/templates/shared/avatar']({url: url, size: size, options: options})