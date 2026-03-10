#!/usr/bin/env ruby
# frozen_string_literal: true

require "tempfile"
require "open3"

command, expected_file =
  case ARGV[0]
  when "rspec"
    ["bundle exec rspec integration_tests/rspec/ --default-path integration_tests/rspec/", "integration_tests/rspec/expected.txt"]
  else
    abort("Provide rspec or minitest as stdin")
  end

result_tempfile = Tempfile.new("integration-test-results.txt")
expected = File.read(expected_file)

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

