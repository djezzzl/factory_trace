#!/usr/bin/env ruby
# frozen_string_literal: true

require "tempfile"
require "open3"

command =
  case ARGV[0]
  when "rspec"
    "bundle exec rspec integration_tests/rspec/ --default-path integration_tests/rspec/"
  when "minitest"
    "bundle exec ruby integration_tests/minitest/test_test.rb"
  else
    abort("Provide rspec or minitest as argument")
  end

result_tempfile = Tempfile.new("integration-test-results.txt")
expected = File.read("integration_tests/single-step-expected.txt")

stdout, stderr, status = Open3.capture3(
  {
    "FB_TRACE_FILE" => result_tempfile.path
  },
  command
)

abort("Error:\n#{stderr}\nStdout:\n#{stdout}") unless status.success?

result = File.read(result_tempfile)
if result != expected
  abort("Got:\n#{result}\nExpected:\n#{expected}\nStdout:\n#{stdout}")
else
  puts "Tests passed!"
end
