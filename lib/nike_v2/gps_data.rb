module NikeV2
  class GpsData < Resource
    extend Forwardable
    def_delegator :@activity, :access_token

    def initialize(attributes = {})
      raise "#{self.class} requires an activity." unless attributes.keys.include?(:activity)
      set_attributes(attributes)
      super(fetch_data)
    end

    private
    def api_url
      self.activity.send(:api_url) + '/gps'
    end
  end
end