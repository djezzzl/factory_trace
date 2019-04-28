# External dependencies
require 'factory_bot'
# Library
require 'factory_trace/configuration'
require 'factory_trace/version'
require 'factory_trace/tracker'
require 'factory_trace/check_unused'
require 'factory_trace/printer'
# Integrations
require 'integrations/rspec'

module FactoryTrace
  class << self
    def start
      return unless configuration.enabled

      tracker.track!
    end

    def stop
      return unless configuration.enabled

      result = CheckUnused.new(tracker.storage).check!

      printer.print(result)
    end

    def configure
      yield(configuration)
    end

    private

    def tracker
      @tracker ||= Tracker.new
    end

    def printer
      @printer ||= Printer.new(configuration.out)
    end

    def configuration
      @configuration ||= Configuration.new
    end
  end
end
