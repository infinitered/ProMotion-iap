# -*- encoding: utf-8 -*-
Gem::Specification.new do |spec|
  spec.name          = "ProMotion-iap"
  spec.version       = "0.1.0"
  spec.authors       = ["Jamon Holmgren", "Kevin VanGelder"]
  spec.email         = ["jamon@clearsightstudio.com", "kevin@clearsightstudio.com"]
  spec.description   = %q{Adds in-app purchase support to ProMotion.}
  spec.summary       = %q{Adds in-app purchase support to ProMotion.}
  spec.homepage      = "https://github.com/clearsightstudio/ProMotion-iap"
  spec.license       = "MIT"

  files = []
  files << 'README.md'
  files.concat(Dir.glob('lib/**/*.rb'))
  spec.files         = files
  spec.test_files    = spec.files.grep(%r{^(spec)/})
  spec.require_paths = ["lib"]

  # spec.add_dependency "ProMotion", "~> 2.0"
  spec.add_development_dependency "motion-stump", "~> 0.3"
  spec.add_development_dependency "motion-redgreen", "~> 1.0"
  spec.add_development_dependency "rake"
end
