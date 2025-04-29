# frozen_string_literal: true

Gem::Specification.new do |s|
  s.name = "spssio"
  s.summary = "Ruby bindings for spssdio"
  s.version = "0.0.2"
  s.author = "Scott Brickner"
  s.files = [
    "bin/change_install_names.rb",
    "lib/spss/libspssdio.rb",
    "lib/spss/status.rb",
    "lib/spss/reader.rb",
    "lib/spss/api.rb",
    "lib/spssio.rb"
  ] + Dir["ext/**/*"]

  s.description = "Ruby bindings for IBM SPSS Statistics Input/Output Module"
  s.email = "scottb@brickner.net"

  s.required_ruby_version = ">= 2.5.3"

  s.add_dependency "ffi", "~> 1.0"

  s.metadata["rubygems_mfa_required"] = "true"
end
