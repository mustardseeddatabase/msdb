require File.expand_path("../lib/delegate_multiparameter/version", __FILE__)

Gem::Specification.new do |s|
  s.name        = "delegate_multiparameter"
  s.version     = DelegateMultiparameter::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Les Nightingill"]
  s.email       = ["codehacker@comcast.net"]
  s.homepage    = ""
  s.summary     = %q{Gem plugin for activerecord to allow delegation of multiparameter 
                     (date, time) methods}
  s.description = %q{Heavily based on Jon Leighton's delegate_temporal plugin, 
                     https://github.com/jonleighton/delegate_temporal, but updated for Rails 3}
  s.rubyforge_project = "delegate_multiparameter"
  s.required_rubygems_version = ">= 1.3.6"
  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.require_path = 'lib'

end

