# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "viki/version"

Gem::Specification.new do |s|
  s.name        = "viki"
  s.version     = Viki::VERSION
  s.authors     = ["Joost van Amersfoort", "Cedric Chin", "Tommi Lew"]
  s.email       = ["engineering@viki.com"]
  s.homepage    = "http://dev.viki.com"
  s.summary     = %q{TODO: Write a gem summary}
  s.description = %q{TODO: Write a gem description}

  s.rubyforge_project = "viki"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  # specify any dependencies here; for example:
  s.add_development_dependency "rspec", "~> 2.10.0"
  s.add_development_dependency "vcr", "~> 2.2.2"
  s.add_development_dependency "webmock", "~> 1.8.7"
  s.add_development_dependency "excon", "~> 0.9.6"
  s.add_runtime_dependency     "httparty", "~> 0.8.3"
  s.add_runtime_dependency     "multi_json", "~> 1.3.6"

end
