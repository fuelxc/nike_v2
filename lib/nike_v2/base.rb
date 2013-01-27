module NikeV2
  class Base
    def initialize(attributes={})
      @created_at = attributes.delete('created_at')
      set_attributes(attributes)
    end

    private
    def set_attributes(attributes)
      attributes.each do |(attr, val)|
        attr = attr.to_s.underscore
        instance_variable_set("@#{attr}", val)
        instance_eval "def #{attr}() @#{attr} end"
      end
    end
  end
end