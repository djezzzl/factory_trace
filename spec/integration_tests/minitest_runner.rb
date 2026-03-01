#!/usr/bin/env ruby
# frozen_string_literal: true

require "tempfile"

result_tempfile = Tempfile.new("integration-test-results.txt")
deprecation_tempfile = Tempfile.new("integration-test-deprecations.txt")
`FB_TRACE_FILE=#{result_tempfile.path} bundle exec ruby spec/integration_tests/minitest/factory_trace_test.rb 2> #{deprecation_tempfile.path}`

result = File.read(result_tempfile)
expected = File.read("spec/integration_tests/minitest/expected.txt")

abort("Got:\n#{result}\nExpected:\n#{expected}") if result != expected

deprecation = File.read(deprecation_tempfile)

abort("Got:\n#{deprecation}\nExpected:nothing") unless deprecation.empty?
