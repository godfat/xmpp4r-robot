# -*- encoding: utf-8 -*-
# stub: xmpp4r-robot 0.3.0 ruby lib

Gem::Specification.new do |s|
  s.name = "xmpp4r-robot".freeze
  s.version = "0.3.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["Lin Jen-Shin (godfat)".freeze]
  s.date = "2017-01-04"
  s.description = "Simple XMPP client built upon xmpp4r. Intended for building simple robots.".freeze
  s.email = ["godfat (XD) godfat.org".freeze]
  s.files = [
  ".gitignore".freeze,
  ".gitmodules".freeze,
  ".travis.yml".freeze,
  "CHANGES.md".freeze,
  "Gemfile".freeze,
  "LICENSE".freeze,
  "README.md".freeze,
  "Rakefile".freeze,
  "lib/xmpp4r-robot.rb".freeze,
  "lib/xmpp4r/robot.rb".freeze,
  "task/README.md".freeze,
  "task/gemgem.rb".freeze,
  "xmpp4r-robot.gemspec".freeze]
  s.homepage = "https://github.com/godfat/xmpp4r-robot".freeze
  s.licenses = ["Apache License 2.0".freeze]
  s.rubygems_version = "2.6.8".freeze
  s.summary = "Simple XMPP client built upon xmpp4r. Intended for building simple robots.".freeze

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<xmpp4r>.freeze, ["~> 0.5"])
    else
      s.add_dependency(%q<xmpp4r>.freeze, ["~> 0.5"])
    end
  else
    s.add_dependency(%q<xmpp4r>.freeze, ["~> 0.5"])
  end
end
