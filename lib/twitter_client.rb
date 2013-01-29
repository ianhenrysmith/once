class TwitterClient
  include HTTParty
  base_uri 'api.twitter.com'
  
  class << self
    def get_tw_embed_code(id)
      response = self.get("/1/statuses/oembed.json?id=#{id}&width=270")
      if response.code == 200
        response.parsed_response["html"]
      end
    end
  end
end