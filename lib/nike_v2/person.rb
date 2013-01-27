module NikeV2
  class Person < Resource

    def initialize(attributes = {})
      raise "#{self.class} requires an access_token." unless attributes.keys.include?(:access_token)
      super
    end

    def summary
      @summary ||= NikeV2::Summary.new(:person => self)
    end

    def activities
      @activities ||= NikeV2::Activities.new(:person => self)
    end

  end
end