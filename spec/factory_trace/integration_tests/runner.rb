#!/usr/bin/env ruby

require 'tempfile'

tempfile = Tempfile.new('integration-test-results.txt')
`FB_TRACE_FILE=#{tempfile.path} bundle exec rspec spec/factory_trace/integration_tests/`
result = File.read(tempfile)
expected = File.read('spec/factory_trace/integration_tests/expected.txt')

abort("Got:\n#{result}\nExpected:\n#{expected}") if result != expected
