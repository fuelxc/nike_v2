module NikeV2
  class Summary < Resource
    extend Forwardable
    def_delegator :@person, :access_token
    
    API_URL = '/me/sport'

    def initialize(attributes = {})
      raise "#{self.class} requires a person." unless attributes.keys.include?(:person)
      set_attributes(attributes)
      super(fetch_data)
    end
  end
end