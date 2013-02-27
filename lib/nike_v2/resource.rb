module NikeV2
  class Resource < Base
    include HTTParty

    base_uri 'https://api.nike.com'

    def initialize(attributes={})
      super(attributes)
    end

    def fetch_data(*args)
      args.unshift(api_url)
      get(*args).parsed_response
    end

    def get(*args, &block)
      build_options(args)
      self.class.get(*args, &block)
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
  end
end