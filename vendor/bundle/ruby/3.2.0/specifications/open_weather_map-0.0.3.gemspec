# -*- encoding: utf-8 -*-
# stub: open_weather_map 0.0.3 ruby lib

Gem::Specification.new do |s|
  s.name = "open_weather_map".freeze
  s.version = "0.0.3"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["otukutun".freeze]
  s.date = "2015-01-02"
  s.description = "OpenWeatherMap Api Wrapper. It can use city and geocode api.".freeze
  s.email = ["orehaorz@gmail.com".freeze]
  s.homepage = "".freeze
  s.licenses = ["MIT".freeze]
  s.rubygems_version = "3.4.12".freeze
  s.summary = "OpenWeatherMap Api Wrapper".freeze

  s.installed_by_version = "3.4.12" if s.respond_to? :installed_by_version

  s.specification_version = 4

  s.add_development_dependency(%q<bundler>.freeze, ["~> 1.7"])
  s.add_development_dependency(%q<rake>.freeze, ["~> 10.0"])
  s.add_development_dependency(%q<rspec>.freeze, [">= 0"])
  s.add_development_dependency(%q<rest-client>.freeze, ["~> 1.7.2"])
end
