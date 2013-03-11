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
      summary_data = fetch_data
      initialization_data = {}
      if summary_data
        if summary_data.has_key?('experienceTypes')
          initialization_data = {
            'activity_types' => summary_data['experienceTypes'].collect{|a| ExperienceType.new(a)}
          }
        end
        if summary_data.has_key?('summaries')
          summary_data['summaries'].each do |data|
            initialization_data[data['experienceType'].downcase] = {}
            data['records'].each do |record|
              initialization_data[data['experienceType'].downcase][record['recordType']] = record['recordValue']
            end
          end
        end
      end

      initialization_data
    end
  end
end