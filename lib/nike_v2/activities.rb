require 'enumerator'
module NikeV2
  class Activities < Resource
    include Enumerable
    extend Forwardable

    API_ARGS = [:offset, :count, :start_date, :end_date]

    def_delegators :@activities_array, :[]=, :<<, :[], :count, :length, :each, :first, :last, :collect
    def_delegator :@person, :access_token
    
    API_URL = '/me/sport/activities'

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
      unless self.paging['next'].blank?
        fetch_and_build_activities 
      end
    end

    def fetch_all
      until self.paging['next'].blank? do
        fetch_and_build_activities 
      end
    end

    def fuelpoints_during(start_time, end_time)
      #reject activities that are not on the right date
    end

    private
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
      activities = fetch_data(url, {query: query})
      build_activities(activities.delete('data'))

      @paging = activities.delete('paging')
    end
  end
end