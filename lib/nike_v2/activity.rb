require 'nike_v2/metrics'
module NikeV2
  class Activity < Resource
    extend Forwardable
    def_delegator :@person, :access_token

    Metrics::METRIC_TYPES.each do |type|
      self.class_eval do 
        def_delegator :metrics, "total_#{type.downcase}"
        def_delegator :metrics, type.downcase
        def_delegator :metrics, "total_#{type.downcase}_during"
      end
    end

    API_URL = '/v1/me/sport/activities'

    def initialize(attributes = {})
      raise "#{self.class} requires s person." unless attributes.keys.include?(:person)
      raise "#{self.class} requires an activityId." unless attributes.keys.include?('activityId')

      build_metrics(attributes)
      super(attributes)
    end

    def tz
      TZInfo::Timezone.get(self.activity_time_zone)
    end

    def gps_data
      @gps_data ||= NikeV2::GpsData.new(:activity => self)
    end

    def metrics
      load_data unless @metrics.is_a?(NikeV2::Metrics)
      @metrics
    end

    def load_data
      data = fetch_data
      build_metrics(data)
      set_attributes(data)

      true
    end

    def started_at
      @started_at ||= Time.parse(self.start_time.gsub('Z', '-') + '00:00')
    end

    # some reason activities aren't always complete so we need metrics to figure out how long they are
    def ended_at
      @ended_at ||= self.respond_to?(:end_time) ? Time.parse(self.end_time.gsub('Z', '-') + '00:00') : started_at + (metrics.durations.to.seconds).to_f 
    end

    def to_tz(time)
      if time.respond_to?(:strftime)
        return Time.parse(time.strftime('%Y-%m-%d %H:%M:%S ' + self.tz.to_s))
      else
        return Time.parse(time + ' ' + self.tz.to_s)
      end
    end

    def tags_as_hash
      Hash[tags.map {|k| [k['tagType'].downcase.to_sym, k['tagValue']] }]
    end

    private 
    def api_url
      API_URL + "/#{self.activity_id}"
    end

    def build_metrics(data)
      metrics = data.delete('metrics') || []
      @metrics = metrics.empty? ? nil : NikeV2::Metrics.new(self, metrics)
    end
  end
end
