module NikeV2
  class Resource < Base
    include HTTParty

    base_uri 'https://api.nike.com'

    def initialize(attributes={})
      super(attributes)
    end

    def fetch_data
      get(api_url).parsed_response
    end

    def get(*args, &block)
      unless has_options?(args)
        query = { 'access_token' => access_token }
        headers = { 'Accept' => 'application/json', 'appid' => app_id }
        options = { query: query, headers: headers }
        args << options
      end
      self.class.get(*args, &block)
    end

    private

    def app_id
      #TODO: make this a config yaml
      'nike'
    end

    def has_options?(args)
      args.last.class.is_a?(Hash) && args.last.keys.any?{ |key| %w[basic_auth body headers no_follow query].include?(key) }
    end

    def api_url
      self.class.const_get('API_URL')
    end
  end
end