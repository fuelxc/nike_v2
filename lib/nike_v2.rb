require 'alchemist'
require 'forwardable'
require 'ext/core_ext'

module NikeV2
  def self.configuration
    @configuration ||=  Configuration.new
  end

  def self.configure
    yield(configuration) if block_given?
  end

  class Configuration
    attr_accessor :cache

    def initialize
      @cache = false
    end
  end
end

require 'nike_v2/base'
require 'nike_v2/metric'
require 'nike_v2/metrics'
require 'nike_v2/experience_type'
require 'nike_v2/resource'
require 'nike_v2/person'
require 'nike_v2/activity'
require 'nike_v2/activities'
require 'nike_v2/summary'
require 'nike_v2/gps_data'