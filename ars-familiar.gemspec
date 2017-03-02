# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'ars/familiar/version'

Gem::Specification.new do |spec|
  spec.name          = "ars-familiar"
  spec.version       = Ars::Familiar::VERSION
  spec.authors       = ["Michael Lee Vazquez"]
  spec.email         = ["magnus.nothus@gmail.com"]

  spec.summary       = %q{ars-familiar-#{Ars::Familiar::VERSION}}
  spec.description   = %q{Ruby Object Metadata Reflector}
  spec.homepage      = "http://github.com/cunningfolk/ars-familiar"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  %w[].each do |lib_name|
    if Ars::Familiar::VERSION =~ /[a-zA-Z]+/
      spec.add_runtime_dependency "ars-#{lib_name}", "= #{Ars::Familiar::VERSION}"
    else
      spec.add_runtime_dependency "ars-#{lib_name}", "~> #{Ars::Familiar::VERSION.sub(/^((?:\d+\.){2}).*$/, '\1.0')}"
    end
  end

  spec.add_runtime_dependency 'activesupport'

end
