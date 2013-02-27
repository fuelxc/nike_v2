module NikeV2
  class Person < Resource

    def initialize(attributes = {})
      raise "#{self.class} requires an access_token." unless attributes.keys.include?(:access_token)
      super
    end

    def summary
      @summary ||= NikeV2::Summary.new(:person => self)
    end

    def activities(count=5)
      # Added by: Parth Barot, 27 Feb,2013.
      # Passing 'count' to load records specified by user.
      @activities ||= NikeV2::Activities.new(:person => self, :count => count)
    end

  end
end