# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'qreport_ar/version'

Gem::Specification.new do |spec|
  spec.name          = "qreport_ar"
  spec.version       = QreportAr::VERSION
  spec.authors       = ["Kurt Stephens"]
  spec.email         = ["ks.github@kurtstephens.com"]
  spec.description   = %q{ActiveRecord model for Qreport::ReportRun.}
  spec.summary       = %q{ActiveRecord model for Qreport::ReportRun.}
  spec.homepage      = "http://github.com/kstephens/qreport_ar"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake", "~> 10.1"
  spec.add_development_dependency "rspec", '~> 2.14'
  spec.add_development_dependency "simplecov", '~> 0.7'
  spec.add_development_dependency "guard-rspec", "~> 4.0"
end
