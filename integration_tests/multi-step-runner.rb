#!/usr/bin/env ruby
# frozen_string_literal: true

require "tempfile"
require "open3"

trace_command =
  case ARGV[0]
  when "rspec"
    "bundle exec rspec integration_tests/rspec/ --default-path integration_tests/rspec/"
  when "minitest"
    "bundle exec ruby integration_tests/minitest/test_test.rb"
  else
    abort("Provide rspec or minitest as argument")
  end

trace_tempfile = Tempfile.new("trace_tempfile.json")

stdout, stderr, status = Open3.capture3(
  {
    "FB_TRACE" => "trace_only",
    "FB_TRACE_FILE" => trace_tempfile.path
  },
  trace_command
)
abort("Error:\n#{stderr}\nStdout:\n#{stdout}") unless status.success?

result_tempfile = Tempfile.new("integration-test-results.txt")
expected = File.read("integration_tests/multi-step-expected.txt")
stdout, stderr, _ = Open3.capture3(
  {
    "FB_TRACE_FILE" => result_tempfile.path
  },
  "bundle exec factory_trace #{trace_tempfile.path}"
)
abort("Error:\n#{stderr}\nStdout:\n#{stdout}") unless stderr.empty? || stdout.empty?

result = File.read(result_tempfile)
if result != expected
  abort("Got:\n#{result}\nExpected:\n#{expected}\nStdout:\n#{stdout}")
else
  puts "Tests passed!"
end
