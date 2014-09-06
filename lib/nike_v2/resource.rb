require 'httparty'
require 'httparty_sober'
module NikeV2
  class Resource < Base
    include HTTParty
    include HTTParty::Sober

    base_uri 'https://api.nike.com/v1'

    RESP_MSG_INVALID_TOKEN = 'invalid_token'

    if NikeV2.configuration.cache
      cache NikeV2.configuration.cache
    end

    def initialize(attributes={})
      super(attributes)
    end

    def fetch_data(*args)
      args.unshift(api_url)
      resp = get(*args).parsed_response.clone

      if !resp['error'].nil? && resp['error'] == RESP_MSG_INVALID_TOKEN
        raise "#{self.class} invalid or expired token, can not fetch data from server."   
      end
      resp
    end

    def get(*args, &block)
      build_options(args)
      self.class.send(get_method, *args, &block)
    end

    private

    def build_options(args)
      query = has_options?(args) ? args.pop : {}

      query.merge!('access_token' => access_token)
      headers = { 'Accept' => 'application/json', 'appid' => app_id }
      options = { query: query, headers: headers }

      args << options
    end


    def app_id
      #TODO: make this a config yaml
      'nike'
    end

    def has_options?(args)
      args.last.is_a?(Hash)
    end

    def api_url
      self.class.const_get('API_URL')
    end

    def get_method
      if NikeV2.configuration.cache
        'get_with_caching'
      else
        'get'
      end
    end
  end
end