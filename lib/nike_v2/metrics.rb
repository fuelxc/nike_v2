require 'enumerator'
module NikeV2
  class Metrics
    include Enumerable
    extend Forwardable

    def_delegators :@metrics_array, :[]=, :<<, :[], :count, :length, :each, :first, :last

    METRIC_TYPES = %w(FUEL CALORIES DISTANCE STEPS)

    def initialize(activity, data_set)
      @activity = activity
      @metrics_array = []
      build_metrics(data_set)
      self
    end

    METRIC_TYPES.each do |type|
      method_var_name = 'total_' + type.downcase
      instance_variable_set('@' + method_var_name, 0.00)
      define_method(method_var_name){ ivar = instance_variable_get('@' + method_var_name); ivar ||= sum_of_type(type)}

      define_method(method_var_name + '_during'){|*args| sum_of_type_during(type, *args)}
    end

    def duration
      @metrics_array.collect(&:duration).sort.first
    end

    private
    def build_metrics(data_set)
      data_set.each do |metric|
        self << NikeV2::Metric.new(@activity, metric)
      end
    end

    def sum_of_type(type)
      @metrics_array.select{|m| m.type == type}.collect(&:total).inject(:+) || 0.00
    end

    def sum_of_type_during(type, *args)
      @metrics_array.select{|m| m.type == type}.collect{|m| m.total_during(*args)}.inject(:+) || 0.00
    end
  end
end