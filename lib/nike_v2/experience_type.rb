module NikeV2
  class ExperienceType
    TO_S_MAP = {
      'fuelband' => 'Fuel Band',
      'npluskinecttrg' => 'Nike+ Kinect',
      'running' => 'Running'
    }

    def initialize(code)
      @code = code
    end

    def code
      @code
    end

    def to_s
      TO_S_MAP[code.downcase]
    end
  end
end