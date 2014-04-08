# -*- encoding: utf-8 -*-
# stub: xmpp4r-robot 0.3.0 ruby lib

Gem::Specification.new do |s|
  s.name = "xmpp4r-robot"
  s.version = "0.3.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["Lin Jen-Shin (godfat)"]
  s.date = "2014-04-08"
  s.description = "Simple XMPP client built upon xmpp4r. Intended for building simple robots."
  s.email = ["godfat (XD) godfat.org"]
  s.files = [
  ".gitignore",
  ".gitmodules",
  ".travis.yml",
  "CHANGES.md",
  "Gemfile",
  "LICENSE",
  "README.md",
  "Rakefile",
  "lib/xmpp4r-robot.rb",
  "lib/xmpp4r/robot.rb",
  "task/README.md",
  "task/gemgem.rb",
  "xmpp4r-robot.gemspec"]
  s.homepage = "https://github.com/godfat/xmpp4r-robot"
  s.licenses = ["Apache License 2.0"]
  s.rubygems_version = "2.2.2"
  s.summary = "Simple XMPP client built upon xmpp4r. Intended for building simple robots."

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<xmpp4r>, ["~> 0.5"])
    else
      s.add_dependency(%q<xmpp4r>, ["~> 0.5"])
    end
  else
    s.add_dependency(%q<xmpp4r>, ["~> 0.5"])
  end
end
