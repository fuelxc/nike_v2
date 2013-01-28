module NikeV2
  class Summary < Resource
    extend Forwardable
    def_delegator :@person, :access_token
    
    API_URL = '/me/sport'

    def initialize(attributes = {})
      raise "#{self.class} requires a person." unless attributes.keys.include?(:person)
      set_attributes(attributes)
      super(initialize_data)
    end

    private
    def initialize_data
      initialization_data = {}
      fetch_data['summaries'].each do |data|
        initialization_data[data['experienceType'].downcase] = data['records']
      end
      initialization_data
    end
  end
end