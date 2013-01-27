require 'enumerator'
module NikeV2
  class Activities < Resource
    include Enumerable
    extend Forwardable

    def_delegators :@activities_array, :[]=, :<<, :[], :count, :length, :each
    def_delegator :@person, :access_token
    
    API_URL = '/me/sport/activities'

    def initialize(attributes = {})
      raise "#{self.class} requires a person." unless attributes.keys.include?(:person)
      set_attributes(attributes)
      @activities_array = []

      #TODO: make it pass blocks
      activities = fetch_data
      activities.delete('data').each do |data|
        self << NikeV2::Activity.new({:person => self}.merge(data))
      end
      super(activities)
    end
  end
end