require 'enumerator'
module NikeV2
  class Metrics
    include Enumerable
    extend Forwardable

    def_delegators :@metrics_array, :[]=, :<<, :[], :count, :length, :each, :first, :last

    def initialize(activity, data_set)
      @activity = activity
      @metrics_array = []
      build_metrics(data_set)
    end

    def fuel_points
      @fuel_points ||= sum_of_type('FUELPOINTS')
    end

    def calories
      @fuel_points ||= sum_of_type('CALORIES')
    end

    def distance
      @fuel_points ||= sum_of_type('DISTANCE')
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
  end
end