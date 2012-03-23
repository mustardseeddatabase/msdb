# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "db_check/version"

Gem::Specification.new do |s|
  s.name        = "db_check"
  s.version     = DbCheck::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Les Nightingill"]
  s.email       = ["codehacker@comcast.net"]
  s.homepage    = ""
  s.summary     = %q{A variety of database checking tools}
  s.description = %q{A home for database tools to avoid cluttering up the application}

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end

