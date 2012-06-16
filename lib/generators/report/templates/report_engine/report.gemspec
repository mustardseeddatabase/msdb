# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "engine_name/version"

Gem::Specification.new do |s|
  s.name        = "engine_name"
  s.version     = ENGINE_NAME::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["automatically generated"]
  s.email       = ["auto@example.net"]
  s.homepage    = ""
  s.summary     = %q{Report generation engine}
  s.description = %q{Includes all the controllers, models, routes and templates to produce MS Word (or other) reports}

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
