# FactoryTrace

[![Gem Version][3]][4]
[![][1]][10]
[![][2]][11]
[![][5]][6]

The main goal of the project is to provide an easy way to maintain [FactoryBot](https://github.com/thoughtbot/factory_bot)
inside your project in a good shape.

> If the project helps you or your organization, I would be very grateful if you [contribute][13] or [donate][14].  
> Your support is an incredible motivation and the biggest reward for my hard work.

Follow me and stay tuned for the updates:
- [LinkedIn](https://www.linkedin.com/in/evgeniydemin/)
- [Medium](https://evgeniydemin.medium.com/)
- [Twitter](https://twitter.com/EvgeniyDemin/)
- [GitHub](https://github.com/djezzzl)

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

## Funding

### Open Collective Backers

You're an individual who wants to support the project with a monthly donation. Your logo will be available on the Github page. [[Become a backer](https://opencollective.com/factory_trace#backer)]

<a href="https://opencollective.com/factory_trace/backer/0/website" target="_blank"><img src="https://opencollective.com/factory_trace/backer/0/avatar.svg"></a>
<a href="https://opencollective.com/factory_trace/backer/1/website" target="_blank"><img src="https://opencollective.com/factory_trace/backer/1/avatar.svg"></a>
<a href="https://opencollective.com/factory_trace/backer/2/website" target="_blank"><img src="https://opencollective.com/factory_trace/backer/2/avatar.svg"></a>
<a href="https://opencollective.com/factory_trace/backer/3/website" target="_blank"><img src="https://opencollective.com/factory_trace/backer/3/avatar.svg"></a>
<a href="https://opencollective.com/factory_trace/backer/4/website" target="_blank"><img src="https://opencollective.com/factory_trace/backer/4/avatar.svg"></a>
<a href="https://opencollective.com/factory_trace/backer/5/website" target="_blank"><img src="https://opencollective.com/factory_trace/backer/5/avatar.svg"></a>
<a href="https://opencollective.com/factory_trace/backer/6/website" target="_blank"><img src="https://opencollective.com/factory_trace/backer/6/avatar.svg"></a>
<a href="https://opencollective.com/factory_trace/backer/7/website" target="_blank"><img src="https://opencollective.com/factory_trace/backer/7/avatar.svg"></a>
<a href="https://opencollective.com/factory_trace/backer/8/website" target="_blank"><img src="https://opencollective.com/factory_trace/backer/8/avatar.svg"></a>
<a href="https://opencollective.com/factory_trace/backer/9/website" target="_blank"><img src="https://opencollective.com/factory_trace/backer/9/avatar.svg"></a>
<a href="https://opencollective.com/factory_trace/backer/10/website" target="_blank"><img src="https://opencollective.com/factory_trace/backer/10/avatar.svg"></a>
<a href="https://opencollective.com/factory_trace/backer/11/website" target="_blank"><img src="https://opencollective.com/factory_trace/backer/11/avatar.svg"></a>
<a href="https://opencollective.com/factory_trace/backer/12/website" target="_blank"><img src="https://opencollective.com/factory_trace/backer/12/avatar.svg"></a>
<a href="https://opencollective.com/factory_trace/backer/13/website" target="_blank"><img src="https://opencollective.com/factory_trace/backer/13/avatar.svg"></a>
<a href="https://opencollective.com/factory_trace/backer/14/website" target="_blank"><img src="https://opencollective.com/factory_trace/backer/14/avatar.svg"></a>
<a href="https://opencollective.com/factory_trace/backer/15/website" target="_blank"><img src="https://opencollective.com/factory_trace/backer/15/avatar.svg"></a>
<a href="https://opencollective.com/factory_trace/backer/16/website" target="_blank"><img src="https://opencollective.com/factory_trace/backer/16/avatar.svg"></a>
<a href="https://opencollective.com/factory_trace/backer/17/website" target="_blank"><img src="https://opencollective.com/factory_trace/backer/17/avatar.svg"></a>
<a href="https://opencollective.com/factory_trace/backer/18/website" target="_blank"><img src="https://opencollective.com/factory_trace/backer/18/avatar.svg"></a>
<a href="https://opencollective.com/factory_trace/backer/19/website" target="_blank"><img src="https://opencollective.com/factory_trace/backer/19/avatar.svg"></a>
<a href="https://opencollective.com/factory_trace/backer/20/website" target="_blank"><img src="https://opencollective.com/factory_trace/backer/20/avatar.svg"></a>
<a href="https://opencollective.com/factory_trace/backer/21/website" target="_blank"><img src="https://opencollective.com/factory_trace/backer/21/avatar.svg"></a>
<a href="https://opencollective.com/factory_trace/backer/22/website" target="_blank"><img src="https://opencollective.com/factory_trace/backer/22/avatar.svg"></a>
<a href="https://opencollective.com/factory_trace/backer/23/website" target="_blank"><img src="https://opencollective.com/factory_trace/backer/23/avatar.svg"></a>
<a href="https://opencollective.com/factory_trace/backer/24/website" target="_blank"><img src="https://opencollective.com/factory_trace/backer/24/avatar.svg"></a>
<a href="https://opencollective.com/factory_trace/backer/25/website" target="_blank"><img src="https://opencollective.com/factory_trace/backer/25/avatar.svg"></a>
<a href="https://opencollective.com/factory_trace/backer/26/website" target="_blank"><img src="https://opencollective.com/factory_trace/backer/26/avatar.svg"></a>
<a href="https://opencollective.com/factory_trace/backer/27/website" target="_blank"><img src="https://opencollective.com/factory_trace/backer/27/avatar.svg"></a>
<a href="https://opencollective.com/factory_trace/backer/28/website" target="_blank"><img src="https://opencollective.com/factory_trace/backer/28/avatar.svg"></a>
<a href="https://opencollective.com/factory_trace/backer/29/website" target="_blank"><img src="https://opencollective.com/factory_trace/backer/29/avatar.svg"></a>

### Open Collective Sponsors

You're an organization that wants to support the project with a monthly donation. Your logo will be available on the Github page. [[Become a sponsor](https://opencollective.com/factory_trace#sponsor)]

<a href="https://opencollective.com/factory_trace/sponsor/0/website" target="_blank"><img src="https://opencollective.com/factory_trace/sponsor/0/avatar.svg"></a>
<a href="https://opencollective.com/factory_trace/sponsor/1/website" target="_blank"><img src="https://opencollective.com/factory_trace/sponsor/1/avatar.svg"></a>
<a href="https://opencollective.com/factory_trace/sponsor/2/website" target="_blank"><img src="https://opencollective.com/factory_trace/sponsor/2/avatar.svg"></a>
<a href="https://opencollective.com/factory_trace/sponsor/3/website" target="_blank"><img src="https://opencollective.com/factory_trace/sponsor/3/avatar.svg"></a>
<a href="https://opencollective.com/factory_trace/sponsor/4/website" target="_blank"><img src="https://opencollective.com/factory_trace/sponsor/4/avatar.svg"></a>
<a href="https://opencollective.com/factory_trace/sponsor/5/website" target="_blank"><img src="https://opencollective.com/factory_trace/sponsor/5/avatar.svg"></a>
<a href="https://opencollective.com/factory_trace/sponsor/6/website" target="_blank"><img src="https://opencollective.com/factory_trace/sponsor/6/avatar.svg"></a>
<a href="https://opencollective.com/factory_trace/sponsor/7/website" target="_blank"><img src="https://opencollective.com/factory_trace/sponsor/7/avatar.svg"></a>
<a href="https://opencollective.com/factory_trace/sponsor/8/website" target="_blank"><img src="https://opencollective.com/factory_trace/sponsor/8/avatar.svg"></a>
<a href="https://opencollective.com/factory_trace/sponsor/9/website" target="_blank"><img src="https://opencollective.com/factory_trace/sponsor/9/avatar.svg"></a>
<a href="https://opencollective.com/factory_trace/sponsor/10/website" target="_blank"><img src="https://opencollective.com/factory_trace/sponsor/10/avatar.svg"></a>
<a href="https://opencollective.com/factory_trace/sponsor/11/website" target="_blank"><img src="https://opencollective.com/factory_trace/sponsor/11/avatar.svg"></a>
<a href="https://opencollective.com/factory_trace/sponsor/12/website" target="_blank"><img src="https://opencollective.com/factory_trace/sponsor/12/avatar.svg"></a>
<a href="https://opencollective.com/factory_trace/sponsor/13/website" target="_blank"><img src="https://opencollective.com/factory_trace/sponsor/13/avatar.svg"></a>
<a href="https://opencollective.com/factory_trace/sponsor/14/website" target="_blank"><img src="https://opencollective.com/factory_trace/sponsor/14/avatar.svg"></a>
<a href="https://opencollective.com/factory_trace/sponsor/15/website" target="_blank"><img src="https://opencollective.com/factory_trace/sponsor/15/avatar.svg"></a>
<a href="https://opencollective.com/factory_trace/sponsor/16/website" target="_blank"><img src="https://opencollective.com/factory_trace/sponsor/16/avatar.svg"></a>
<a href="https://opencollective.com/factory_trace/sponsor/17/website" target="_blank"><img src="https://opencollective.com/factory_trace/sponsor/17/avatar.svg"></a>
<a href="https://opencollective.com/factory_trace/sponsor/18/website" target="_blank"><img src="https://opencollective.com/factory_trace/sponsor/18/avatar.svg"></a>
<a href="https://opencollective.com/factory_trace/sponsor/19/website" target="_blank"><img src="https://opencollective.com/factory_trace/sponsor/19/avatar.svg"></a>
<a href="https://opencollective.com/factory_trace/sponsor/20/website" target="_blank"><img src="https://opencollective.com/factory_trace/sponsor/20/avatar.svg"></a>
<a href="https://opencollective.com/factory_trace/sponsor/21/website" target="_blank"><img src="https://opencollective.com/factory_trace/sponsor/21/avatar.svg"></a>
<a href="https://opencollective.com/factory_trace/sponsor/22/website" target="_blank"><img src="https://opencollective.com/factory_trace/sponsor/22/avatar.svg"></a>
<a href="https://opencollective.com/factory_trace/sponsor/23/website" target="_blank"><img src="https://opencollective.com/factory_trace/sponsor/23/avatar.svg"></a>
<a href="https://opencollective.com/factory_trace/sponsor/24/website" target="_blank"><img src="https://opencollective.com/factory_trace/sponsor/24/avatar.svg"></a>
<a href="https://opencollective.com/factory_trace/sponsor/25/website" target="_blank"><img src="https://opencollective.com/factory_trace/sponsor/25/avatar.svg"></a>
<a href="https://opencollective.com/factory_trace/sponsor/26/website" target="_blank"><img src="https://opencollective.com/factory_trace/sponsor/26/avatar.svg"></a>
<a href="https://opencollective.com/factory_trace/sponsor/27/website" target="_blank"><img src="https://opencollective.com/factory_trace/sponsor/27/avatar.svg"></a>
<a href="https://opencollective.com/factory_trace/sponsor/28/website" target="_blank"><img src="https://opencollective.com/factory_trace/sponsor/28/avatar.svg"></a>
<a href="https://opencollective.com/factory_trace/sponsor/29/website" target="_blank"><img src="https://opencollective.com/factory_trace/sponsor/29/avatar.svg"></a>

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

[1]: https://github.com/djezzzl/factory_trace/actions/workflows/tests.yml/badge.svg?branch=master
[2]: https://github.com/djezzzl/factory_trace/actions/workflows/rubocop.yml/badge.svg?branch=master
[3]: https://badge.fury.io/rb/factory_trace.svg
[4]: https://badge.fury.io/rb/factory_trace
[5]: https://opencollective.com/factory_trace/tiers/badge.svg
[6]: https://opencollective.com/factory_trace#support
[10]: https://github.com/djezzzl/factory_trace/actions/workflows/tests.yml?query=event%3Aschedule
[11]: https://github.com/djezzzl/factory_trace/actions/workflows/rubocop.yml?query=event%3Aschedule
[13]: https://github.com/djezzzl/factory_trace#contributing
[14]: https://opencollective.com/factory_trace#support
