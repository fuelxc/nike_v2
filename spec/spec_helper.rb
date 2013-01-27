require_relative '../lib/nike_v2'
require 'factory_girl'
require 'rspec'
require 'vcr'
require 'webmock'

FactoryGirl.find_definitions

RSpec.configure do |config|
  config.include FactoryGirl::Syntax::Methods
end

VCR.configure do |config|
  config.cassette_library_dir = 'spec/fixtures/nike_api_cassettes'
  config.hook_into :webmock
end