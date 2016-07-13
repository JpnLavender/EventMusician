# -*- encoding: utf-8 -*-
# stub: url 0.3.2 ruby lib

Gem::Specification.new do |s|
  s.name = "url"
  s.version = "0.3.2"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["Tal Atlas"]
  s.date = "2011-07-25"
  s.description = "A simple url object to allow for OO based manipulation and usage of a url"
  s.email = "me@tal.by"
  s.extra_rdoc_files = ["LICENSE", "README.rdoc"]
  s.files = ["LICENSE", "README.rdoc"]
  s.homepage = "http://github.com/talby/url"
  s.rubygems_version = "2.5.1"
  s.summary = "A URL object"

  s.installed_by_version = "2.5.1" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<rspec>, ["~> 2"])
      s.add_development_dependency(%q<rake>, [">= 0"])
      s.add_development_dependency(%q<yard>, [">= 0.7.1"])
    else
      s.add_dependency(%q<rspec>, ["~> 2"])
      s.add_dependency(%q<rake>, [">= 0"])
      s.add_dependency(%q<yard>, [">= 0.7.1"])
    end
  else
    s.add_dependency(%q<rspec>, ["~> 2"])
    s.add_dependency(%q<rake>, [">= 0"])
    s.add_dependency(%q<yard>, [">= 0.7.1"])
  end
end
