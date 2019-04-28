# FactoryTrace

[![Build Status](https://travis-ci.org/djezzzl/factory_trace.svg?branch=master)](https://travis-ci.org/djezzzl/factory_trace)
[![Gem Version](https://badge.fury.io/rb/factory_trace.svg)](https://badge.fury.io/rb/factory_trace)

The main goal of the project is to provide an easy way to maintain [FactoryBot](https://github.com/thoughtbot/factory_bot) 
inside your project in a good shape.

## What it does?

Currently, it only help to find unused `factories` and `traits`.

Example output (from [Rails Example](rails-example)):

```bash
unused trait 'with_phone' of factory 'user'
unused factory 'special_user'
unused global trait 'with_email'
```

## Installation

Add this line to your application's Gemfile in the group you have `factory_bot` or `factory_bot_rails`:

```ruby
gem 'factory_trace'
```

And then execute:
```
$ bundle install
```

Or install it yourself as:

```
$ gem install factory_trace
```

## Usage

Add this line where you want to start tracking usage of `FactoryBot` factories and traits:

```ruby
FactoryTrace.start
```

Add this line where you want to stop tracking and get collected information:

```ruby
FactoryTrace.stop
```

### RSpec

Add the following to your [RSpec](https://github.com/rspec/rspec) configuration:

```ruby
RSpec.configure do |config|
  config.before(:suite) { FactoryTrace.start }
  config.after(:suite) { FactoryTrace.stop }
end
```

Then run all your specs.

## Configuration

You can configure `FactoryTrace`:

```ruby
FactoryTrace.configure do |config|
  # default is true
  config.enabled = true 
  
  # default is nil
  # when nil outputs to STDOUT instead 
  config.path = 'log/factory_trace.txt' 
end
```

## Development

After checking out the repo, run `bundle install` to install dependencies. 
Then, run `rake spec` to run the tests.
To install this gem onto your local machine, run `bundle exec rake install`. 
To release a new version, update the version number in `version.rb`, 
and then run `bundle exec rake release`, which will create a git tag for the version, 
push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

[Bug reports](https://github.com/djezzzl/factory_trace/issues) and [pull requests](https://github.com/djezzzl/factory_trace/pulls) are welcome on GitHub. 
This project is intended to be a safe, welcoming space for collaboration, and contributors are expected 
to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the *FactoryTrace* project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](CODE_OF_CONDUCT.md).

## Changelog

*FactoryTrace*'s changelog is available [here](CHANGELOG.md).

## Copyright

Copyright (c) Evgeniy Demin. See [LICENSE.txt](LICENSE.txt) for further details.
