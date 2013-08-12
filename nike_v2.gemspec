# -*- encoding: utf-8 -*-
require File.expand_path("../lib/nike_v2/version", __FILE__)

Gem::Specification.new do |s|
  s.name        = 'nike_v2'
  s.version     = NikeV2::VERSION
  s.authors     = ["Eric Harrison"]
  s.email       = ["eric@rubynooby.com"]
  s.homepage    = 'https://github.com/fuelxc/nike_v2'
  s.summary     = 'Nike+ API V2 Gem'
  s.description = 'Nike+ API V2 Gem'

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ['lib']

  s.add_runtime_dependency 'httparty', '0.10.2'
  s.add_runtime_dependency "httparty_sober", "0.2.1"
  s.add_runtime_dependency 'alchemist', '0.1.3'
  s.add_runtime_dependency 'tzinfo', '~> 0.3.37'

  s.add_development_dependency 'factory_girl', '~> 4.2.0'
  s.add_development_dependency 'rake', '~> 10.0.3'
  s.add_development_dependency 'rspec', '~> 2.12.0'
  s.add_development_dependency 'vcr', '~> 2.4.0'
  s.add_development_dependency 'webmock', '~> 1.9.0'
end