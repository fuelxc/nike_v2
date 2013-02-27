require 'enumerator'
module NikeV2
  class Activities < Resource
    include Enumerable
    extend Forwardable

    def_delegators :@activities_array, :[]=, :<<, :[], :count, :length, :each, :first, :last
    def_delegator :@person, :access_token
    
    API_URL = '/me/sport/activities'

    def initialize(attributes = {})
      raise "#{self.class} requires a person." unless attributes.keys.include?(:person)
      set_attributes(attributes)
      @activities_array = []

      #TODO: make it pass blocks

      # Added by: Parth Barot, 27 Feb,2013.
      # Passing query on the initial API call, to pass 'count' and load records specified by user.
      #
      activities = fetch_data(API_URL,{query: {:access_token => access_token, count: self.count}})
      if activities.present? && activities['data'].present?
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
      data.each do |activity|
        self << NikeV2::Activity.new({:person => self}.merge(activity))
      end
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