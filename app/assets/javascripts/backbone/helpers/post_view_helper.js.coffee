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
          "<blockquote class='twitter-tweet' width='270'><p>SB9 disc: Sen Irene Aguilar: 'I am more concerned about the danger to our children from unintentional injuries' in shootings. <a href='https://twitter.com/search/%23edcolo'>#edcolo</a> <a href='https://twitter.com/search/%23coleg'>#coleg</a></p>&mdash; EdNewsColorado (@ednews) <a href='https://twitter.com/ednews/status/296064594995183616'>January 29, 2013</a></blockquote>
          <script async src='//platform.twitter.com/widgets.js' charset='utf-8'></script>"
        else
          if post.content && post.content.length > 60
          then post.content.substring(0,60) + "..."
          else post.content
    dropdown: (options={}) =>
      JST['backbone/templates/shared/dropdown'](options)