# frozen_string_literal: true

# External dependencies
require "factory_bot"
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

require "factory_trace/structures/factory"
require "factory_trace/structures/trait"
require "factory_trace/structures/collection"

require "factory_trace/preprocessors/extract_defined"
require "factory_trace/preprocessors/extract_used"

require "factory_trace/processors/find_unused"

require "factory_trace/readers/trace_reader"
require "factory_trace/writers/writer"
require "factory_trace/writers/report_writer"
require "factory_trace/writers/trace_writer"

require "factory_trace/monkey_patches/monkey_patches"
require "factory_trace/monkey_patches/factory"
require "factory_trace/monkey_patches/trait"
require "factory_trace/monkey_patches/enum"
require "factory_trace/monkey_patches/definition_proxy"
require "factory_trace/monkey_patches/dsl"

# Integrations
require "integrations/rspec" if defined?(RSpec::Core)

module FactoryTrace
  class << self
    def start
      return unless configuration.enabled
      trace_definitions! if configuration.trace_definition?

      tracker.track!
    end

    def stop
      return unless configuration.enabled

      if configuration.mode?(:full)
        Writers::ReportWriter.new(configuration.out, configuration).write(Processors::FindUnused.call(defined, used))
      elsif configuration.mode?(:trace_only)
        Writers::TraceWriter.new(configuration.out, configuration).write(defined, used)
      end
    end

    def configure
      yield(configuration)
    end

    def configuration
      @configuration ||= Configuration.new
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

    def trace_definitions!
      FactoryBot::Factory.prepend(FactoryTrace::MonkeyPatches::Factory)
      FactoryBot::Trait.prepend(FactoryTrace::MonkeyPatches::Trait)
      FactoryBot::Enum.prepend(FactoryTrace::MonkeyPatches::Enum)
      FactoryBot::Syntax::Default::DSL.prepend(FactoryTrace::MonkeyPatches::Default::DSL)
      FactoryBot::DefinitionProxy.prepend(FactoryTrace::MonkeyPatches::DefinitionProxy)
    end
  end
end
