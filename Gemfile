source "https://rubygems.org"

gemspec

local_gemfile = "Gemfile.local"

if File.exist?(local_gemfile)
  eval(File.read(local_gemfile))
else
  gem "factory_bot", "~> 6.0"
end
