# External dependencies
require 'factory_bot'
require 'json'
require 'set'
# Library
require 'factory_trace/configuration'
require 'factory_trace/version'
require 'factory_trace/helpers/converter'
require 'factory_trace/helpers/statusable'
require 'factory_trace/tracker'

require 'factory_trace/structures/factory'
require 'factory_trace/structures/trait'
require 'factory_trace/structures/collection'

require 'factory_trace/preprocessors/extract_defined'
require 'factory_trace/preprocessors/extract_used'

require 'factory_trace/processors/find_unused'

require 'factory_trace/readers/trace_reader'
require 'factory_trace/writers/writer'
require 'factory_trace/writers/report_writer'
require 'factory_trace/writers/trace_writer'
# Integrations
require 'integrations/rspec' if defined?(RSpec::Core)

module FactoryTrace
  class << self
    def start
      return unless configuration.enabled

      tracker.track!
    end

    def stop
      return unless configuration.enabled

      # This is required to exclude parent traits from +defined_traits+
      FactoryBot.reload

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
  end
end
