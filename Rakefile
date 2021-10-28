# frozen_string_literal: true

require "bundler/gem_tasks"
require "rspec/core/rake_task"

RSpec::Core::RakeTask.new(:spec)

begin
  require "rubocop/rake_task"
  RuboCop::RakeTask.new
rescue LoadError
  desc "Lint Ruby files with RuboCop"
  task(:rubocop)
end

task default: [:spec, :rubocop]
