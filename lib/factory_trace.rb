# frozen_string_literal: true

# External dependencies
require "active_support"
require "json"
require "set"
require "pathname"
# Library
require "factory_trace/configuration"
require "factory_trace/version"
require "factory_trace/helpers/converter"
require "factory_trace/helpers/statusable"
require "factory_trace/helpers/caller"
require "factory_trace/tracker"
require "factory_trace/fixture_tracker"

require "factory_trace/structures/factory"
require "factory_trace/structures/trait"
require "factory_trace/structures/collection"

require "factory_trace/preprocessors/extract_defined"
require "factory_trace/preprocessors/extract_used"
require "factory_trace/preprocessors/extract_defined_fixtures"

require "factory_trace/processors/find_unused"

require "factory_trace/readers/trace_reader"
require "factory_trace/writers/writer"
require "factory_trace/writers/report_writer"
require "factory_trace/writers/trace_writer"

require "factory_trace/monkey_patches/monkey_patches"
require "factory_trace/monkey_patches/factory"
require "factory_trace/monkey_patches/trait"
require "factory_trace/monkey_patches/definition_proxy"
require "factory_trace/monkey_patches/dsl"

# Integrations
require "integrations/rspec" if defined?(RSpec::Core)
require "integrations/minitest" if defined?(Minitest)

module FactoryTrace
  class << self
    def start
      return unless configuration.enabled
      trace_definitions! if configuration.trace_definition?

      tracker.track! if factory_bot?
      fixture_tracker.track! if fixtures?
    end

    def stop
      return unless configuration.enabled

      # This is required to exclude parent traits from +defined_traits+
      FactoryBot.reload if factory_bot?

      if configuration.mode?(:full)
        writer = Writers::ReportWriter.new(configuration.out, configuration)
        writer.write(Processors::FindUnused.call(defined, used), kind: :factory_bot) if factory_bot?
        writer.write(Processors::FindUnused.call(defined_fixtures, used_fixtures), kind: :fixtures) if fixtures?
      elsif configuration.mode?(:trace_only)
        writer = Writers::TraceWriter.new(configuration.out, configuration)
        writer.write(defined, used, kind: :factory_bot) if factory_bot?
        writer.write(defined_fixtures, used_fixtures, kind: :fixtures) if fixtures?
      end
    end

    def configure
      yield(configuration)
    end

    def configuration
      @configuration ||= Configuration.new
    end

    def factory_bot_register
      @factory_bot_register ||= (FactoryBot::VERSION >= "5.1.0") ? FactoryBot::Internal : FactoryBot
    end

    private

    def used
      @used ||= Preprocessors::ExtractUsed.call(tracker.storage)
    end

    def defined
      @defined ||= Preprocessors::ExtractDefined.call
    end

    def tracker
      @tracker ||= Tracker.new
    end

    def fixture_tracker
      @fixture_tracker ||= FixtureTracker.new
    end

    def defined_fixtures
      @defined_fixtures ||= Preprocessors::ExtractDefinedFixtures.call(configuration.fixture_path)
    end

    def used_fixtures
      @used_fixtures ||= Preprocessors::ExtractUsed.call(fixture_tracker.storage)
    end

    def factory_bot?
      defined?(FactoryBot)
    end

    def fixtures?
      defined?(ActiveRecord::FixtureSet)
    end

    def trace_definitions!
      return unless factory_bot?

      FactoryBot::Factory.prepend(FactoryTrace::MonkeyPatches::Factory)
      FactoryBot::Trait.prepend(FactoryTrace::MonkeyPatches::Trait)
      FactoryBot::Syntax::Default::DSL.prepend(FactoryTrace::MonkeyPatches::Default::DSL)
      FactoryBot::DefinitionProxy.prepend(FactoryTrace::MonkeyPatches::DefinitionProxy)
    end
  end
end
