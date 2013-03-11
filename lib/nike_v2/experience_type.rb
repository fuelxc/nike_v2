module NikeV2
  class ExperienceType
    TO_S_MAP = {
      'fuelband' => 'Fuel Band',
      'npluskinecttrg' => 'Nike+ Kinect',
      'running' => 'Running'
    }

    TO_KEY_MAP = TO_S_MAP.invert

    def initialize(code)
      @code = code
    end

    def code
      @code
    end

    def to_s
      TO_S_MAP[code.downcase]
    end

    def self.code_from_string(string)
      TO_KEY_MAP[string]
    end
  end
end