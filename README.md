# FactoryTrace

[![CircleCI][1]][2]
[![Gem Version][3]][4]

The main goal of the project is to provide an easy way to maintain [FactoryBot](https://github.com/thoughtbot/factory_bot)
inside your project in a good shape.

## What it does?

Currently, it helps to find unused `factories` and `traits`.

Example output (from [Rails RSpec Example](rails-rspec-example)):

```bash
$ FB_TRACE=1 rspec
total number of unique used factories & traits: 3
total number of unique unused factories & traits: 3
unused factory admin => spec/factories.rb:10
unused trait with_address of factory admin => spec/factories.rb:11
unused global trait with_email => spec/factories.rb:16
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

For now, the gem supports [RSpec](https://github.com/rspec/rspec) out of the box.
You don't need to add any hooks. Just run the specs, e.g.

```bash
# output to STDOUT
FB_TRACE=1 rspec
# OR output to any file
FB_TRACE_FILE=log/factory_trace.txt rspec
```

For any other case, add the following line where you want to start
tracking usage of `FactoryBot` factories and traits:

```ruby
FactoryTrace.start
```

Add this line where you want to stop tracking and get collected information:

```ruby
FactoryTrace.stop
```

### Partial execution

Imagine, you run your specs in parts (as many as you need) and then want to track total usage of
factories and traits. For that, we have a `trace_only` mode. You can try following commands [here](rails-rspec-example).

```bash
# one part
FB_TRACE=trace_only FB_TRACE_FILE=fb_trace_result1.json bundle exec rspec spec/first_spec.rb
# another part
FB_TRACE=trace_only FB_TRACE_FILE=fb_trace_result2.json bundle exec rspec spec/second_spec.rb
# output the usage to the console
bundle exec factory_trace fb_trace_result1.json fb_trace_result2.json
# or to the file
FB_TRACE_FILE=fb_report.txt bundle exec factory_trace fb_trace_result1.json fb_trace_result2.json
```

**Note**: `bundle exec factory_trace` won't load your project. Thus it runs fast and it's easier to configure it on CI.

## Configuration

You can configure `FactoryTrace`:

```ruby
FactoryTrace.configure do |config|
  # default ENV.key?('FB_TRACE') || ENV.key?('FB_TRACE_FILE')
  config.enabled = true

  # default is ENV['FB_TRACE_FILE']
  # when nil outputs to STDOUT
  config.path = 'log/factory_trace.txt'

  # default is true when +path+ is nil
  config.color = true

  # default is ENV['FB_TRACE'] || :full
  # can be :full or :trace_only
  config.mode = :full

  # used to trace definitions places
  # default is true
  # can be true or false  
  config.trace_definition = true
end
```

**Tip**: if you have some errors try to disable `trace_definition`. That functionality does
many monkey patches to `FactoryBot`. I will appreciate sharing an error stack trace so I can
fix it.

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

[1]: https://circleci.com/gh/djezzzl/factory_trace/tree/master.svg?style=shield
[2]: https://circleci.com/gh/djezzzl/factory_trace/tree/master
[3]: https://badge.fury.io/rb/factory_trace.svg
[4]: https://badge.fury.io/rb/factory_trace
