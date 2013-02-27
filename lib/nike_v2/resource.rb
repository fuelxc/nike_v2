module NikeV2
  class Resource < Base
    include HTTParty

    base_uri 'https://api.nike.com'

    RESP_MSG_INVALID_TOKEN = 'invalid_token'

    def initialize(attributes={})
      super(attributes)
    end

    def fetch_data(*args)
      args << api_url if args.empty?
      resp = get(*args).parsed_response

      # Added by: Parth Barot, 27 Feb,2013.
      #
      # Raise an exception if token is expired and error message is matching. 
      # We could also throw general error message if error is present, for other errors.
      if resp['error'].present? && resp['error'] == RESP_MSG_INVALID_TOKEN
        raise "#{self.class} invalid or expired token, can not fetch data from server."   
      end
      resp
    end

    def get(*args, &block)
      build_options(args)
      self.class.get(*args, &block)
    end

    private

    def build_options(args)
      query = { 'access_token' => access_token }
      headers = { 'Accept' => 'application/json', 'appid' => app_id }
      options = { query: query, headers: headers }
      if has_options?(args)
        args[-1] = options.merge(args.last)
      else 
        args << options
      end
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