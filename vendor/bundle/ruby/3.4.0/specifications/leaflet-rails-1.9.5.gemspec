# -*- encoding: utf-8 -*-
# stub: leaflet-rails 1.9.5 ruby lib

Gem::Specification.new do |s|
  s.name = "leaflet-rails".freeze
  s.version = "1.9.5".freeze

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["Akshay Joshi".freeze]
  s.date = "2024-07-15"
  s.description = "This gem provides the leaflet.js map display library for your Rails 4+ application.".freeze
  s.email = ["leaflet_rails@akshayjoshi.com".freeze]
  s.homepage = "".freeze
  s.licenses = ["BSD".freeze]
  s.post_install_message = "leaflet-rails: Intent to deprecate on or after 2024-10-01. See repo for details".freeze
  s.rubygems_version = "3.1.6".freeze
  s.summary = "Use leaflet.js with Rails 4/5.".freeze

  s.installed_by_version = "3.7.1".freeze

  s.specification_version = 4

  s.add_runtime_dependency(%q<railties>.freeze, [">= 4.2.0".freeze])
  s.add_runtime_dependency(%q<actionpack>.freeze, [">= 4.2.0".freeze])
  s.add_development_dependency(%q<rspec>.freeze, ["<= 3.4.0".freeze])
  s.add_development_dependency(%q<simplecov-rcov>.freeze, [">= 0".freeze])
end
