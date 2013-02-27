require 'enumerator'
module NikeV2
  class Activities < Resource
    include Enumerable
    extend Forwardable

    API_ARGS = [:offset, :count, :start_date, :end_date]

    def_delegators :@activities_array, :[]=, :<<, :[], :count, :length, :each, :first, :last
    def_delegator :@person, :access_token
    
    API_URL = '/me/sport/activities'

    def initialize(attributes = {})
      raise "#{self.class} requires a person." unless attributes.keys.include?(:person)
      api_args = extract_api_args(attributes)
      set_attributes(attributes)
      @activities_array = []

      #TODO: make it pass blocks
      activities = fetch_data(api_args)
      build_activities(activities.delete('data'))

      super(activities)
    end

    def fetch_more
      unless self.paging['next'].blank?
        url, query = self.paging['next'].match(/^(.*?)\?(.*)$/)[1,2]
        query = query.split(/&/).inject({}){|h,item| k, v = item.split(/\=/); h[k] = v;h}
        activities = fetch_data(url, {query: query})
        build_activities(activities.delete('data'))
        self.paging = activities.delete['paging']
      end
    end

    private
    def build_activities(data)
      if data
        data.each do |activity|
          self << NikeV2::Activity.new({:person => self}.merge(activity))
        end
      end
    end

    def extract_api_args(args)
      args.inject({}){|h,a| h[a.first.camelize] = a.last if API_ARGS.include?(a.first); h}
    end
  end
end