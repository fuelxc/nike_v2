require 'enumerator'
module NikeV2
  class Activities < Resource
    include Enumerable
    extend Forwardable

    API_ARGS = [:offset, :count, :start_date, :end_date]

    def_delegators :@activities_array, :[]=, :<<, :[], :count, :length, :each, :first, :last, :collect
    def_delegator :@person, :access_token

    API_URL = '/v1/me/sport/activities'

    Metrics::METRIC_TYPES.each do |type|
      self.class_eval do 

        method_var_name = 'total_' + type.downcase
        instance_variable_set('@' + method_var_name, 0.00)
        define_method(method_var_name){ ivar = instance_variable_get('@' + method_var_name); ivar ||= sum_of(method_var_name)}


        define_method("total_#{type.downcase}_during") do |start_date, end_date, convert = false|
          @activities_array.reject{|a| ((a.started_at..a.ended_at) & (start_date..end_date)).nil?}.collect{|a| a.send("total_#{type.downcase}_during", start_date, end_date, convert)}.inject(:+)
        end
      end
    end

    def initialize(attributes = {})
      raise "#{self.class} requires a person." unless attributes.keys.include?(:person)
      @build_metrics = attributes.delete(:build_metrics) || false
      api_args = extract_api_args(attributes)
      set_attributes(attributes)
      @activities_array = []


      #TODO: make it pass blocks
      activities = fetch_data(api_args)
      if !activities.nil? && !activities['data'].nil?
        build_activities(activities.delete('data'))
        super(activities)
      end
    end

    def fetch_more
      unless self.paging['next'].nil? || self.paging['next'] == ''
        fetch_and_build_activities 
      end
      self
    end

    def fetch_all
      until (self.paging['next'].nil? || self.paging['next'] == '') do
        fetch_and_build_activities 
      end
      self
    end

    def paging
      @paging ||= ''
    end

    private


    def sum_of(method_var_name)
      self.collect(&:"#{method_var_name}").inject(:+) || 0.00
    end

    def build_activities(data)
      if data
        data.each do |activity|
          self << NikeV2::Activity.new({:person => self}.merge(activity))
        end
      end
      if @build_metrics
        self.collect(&:load_data)
      end

    end

    def extract_api_args(args)
      args.inject({}){|h,a| h[camelize_word(a.first)] = a.last if API_ARGS.include?(a.first); h}
    end

    def camelize_word(word, first_letter_in_uppercase = false)
      if !!first_letter_in_uppercase
        word.to_s.gsub(/\/(.?)/) { "::#{$1.upcase}" }.gsub(/(?:^|_)(.)/) { $1.upcase }
      else
        (word[0].to_s.downcase + camelize_word(word, true)[1..-1]).to_sym
      end
    end

    def fetch_and_build_activities
      url, query = self.paging['next'].match(/^(.*?)\?(.*)$/)[1,2]
      query = query.split(/&/).inject({}){|h,item| k, v = item.split(/\=/); h[k] = v;h}
      activities = fetch_data(query)
      build_activities(activities.delete('data'))

      @paging = activities.delete('paging')
    end
  end
end
