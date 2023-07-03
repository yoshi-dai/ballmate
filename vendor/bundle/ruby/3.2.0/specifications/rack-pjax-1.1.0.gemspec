# -*- encoding: utf-8 -*-
# stub: rack-pjax 1.1.0 ruby lib

Gem::Specification.new do |s|
  s.name = "rack-pjax".freeze
  s.version = "1.1.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["Gert Goet".freeze]
  s.date = "2019-03-24"
  s.description = "Serve pjax responses through rack middleware".freeze
  s.email = ["gert@thinkcreate.nl".freeze]
  s.homepage = "https://github.com/eval/rack-pjax".freeze
  s.licenses = ["MIT".freeze]
  s.rubygems_version = "3.4.12".freeze
  s.summary = "Serve pjax responses through rack middleware".freeze

  s.installed_by_version = "3.4.12" if s.respond_to? :installed_by_version

  s.specification_version = 4

  s.add_runtime_dependency(%q<rack>.freeze, [">= 1.1"])
  s.add_runtime_dependency(%q<nokogiri>.freeze, ["~> 1.5"])
  s.add_development_dependency(%q<rake>.freeze, [">= 0"])
  s.add_development_dependency(%q<rspec>.freeze, [">= 0"])
  s.add_development_dependency(%q<rack-test>.freeze, [">= 0"])
end