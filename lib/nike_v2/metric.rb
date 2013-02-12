module NikeV2
  class Metric

    def initialize(activity, data)
      @activity = activity
      @unit = data['intervalUnit']
      @type = data ['metricType']
      @values = data['values']
    end

    def type
      @type
    end

    def values
      @values
    end

    def total
      @total ||= values.inject(:+)
    end

    def total_during(start, stop)
      during(start, stop).collect(&:to_i).inject(:+)
    end

    def during(start, stop)
      @values[time_to_index(start)..time_to_index(stop)]
    end

    private
    def time_to_index(time)
      difference = time.to_i - @activity.started_at.to_i
      difference.seconds.to.send(@unit.downcase).to_s.to_i
    end
  end
end