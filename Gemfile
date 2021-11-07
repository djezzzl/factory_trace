# frozen_string_literal: true

source "https://rubygems.org"

gemspec

local_gemfile = "Gemfile.local"

if File.exist?(local_gemfile)
  eval_gemfile(local_gemfile)
else
  gem "factory_bot", "~> 6.0"
end

eval_gemfile("gemfiles/rubocop.gemfile")
