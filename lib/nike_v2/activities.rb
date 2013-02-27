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

    # Added by: Parth Barot, 27 Feb,2013.
    # Issue 7
    #
    def fetch_all
      until self.paging['next'].blank? do
        fetch_and_build_activities 
      end
    end

    #######################
    private
    #######################

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
    # Refactored by: Parth Barot, 27 Feb,2013.
    # Needs to be extracted as a private method, to avoid code duplication for new method 'fetch_all'
    #
    def fetch_and_build_activities
      url, query = self.paging['next'].match(/^(.*?)\?(.*)$/)[1,2]
      query = query.split(/&/).inject({}){|h,item| k, v = item.split(/\=/); h[k] = v;h}
      activities = fetch_data(url, {query: query})
      build_activities(activities.delete('data'))
      
      # 1. Changing [] with () for syntax error in '.delete' method call
      
      # 2. Changing "self.paging=" to "@paging", because no accessor method present. 
      # Instead, We can also change this in resource.rb, to define new setter method for each attribute.
      @paging = activities.delete('paging')
    end
  end
end