# frozen_string_literal: true

require_relative "lib/json/pie/version"

Gem::Specification.new do |spec|
  spec.name = "json-pie"
  spec.version = JSON::Pie::VERSION
  spec.authors = ["Emil Kampp"]
  spec.email = ["emil@kampp.me"]

  spec.summary = "JSON:API rails plugin"
  spec.description = "Allow a Rails API to use the JSON:API interface"
  spec.homepage = "https://github.com/ekampp/json-pie"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 2.6.0"

  spec.metadata["allowed_push_host"] = "https://rubygems.org"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage
  spec.metadata["changelog_uri"] = "#{spec.homepage}/CHANGELOG.md"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject do |f|
      (f == __FILE__) || f.match(%r{\A(?:(?:bin|test|spec|features)/|\.(?:git|travis|circleci)|appveyor)})
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  # Uncomment to register a new dependency of your gem
  spec.add_dependency "rails", "<= 7.1"
end
