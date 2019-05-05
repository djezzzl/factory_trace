# External dependencies
require 'factory_bot'
# Library
require 'factory_trace/configuration'
require 'factory_trace/version'
require 'factory_trace/tracker'

require 'factory_trace/find_unused'
require 'factory_trace/storage_handler'

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

      writer.write(results)
    end

    def configure
      yield(configuration)
    end

    def configuration
      @configuration ||= Configuration.new
    end

    private

    def results
      if configuration.mode?(:full)
        FindUnused.call(preprocessed)
      elsif configuration.mode?(:trace_only)
        preprocessed
      end
    end

    def preprocessed
      @preprocessed ||= StorageHandler.prepare(tracker.storage)
    end

    def tracker
      @tracker ||= Tracker.new
    end

    def writer
      @writer ||= Writer.factory(configuration.out, config: configuration)
    end
  end
end
