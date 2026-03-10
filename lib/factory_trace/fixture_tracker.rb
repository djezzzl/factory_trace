# frozen_string_literal: true

module FactoryTrace
  class FixtureTracker
    attr_reader :storage

    def initialize
      @storage = {}
    end

    def track!
      return unless defined?(ActiveRecord::FixtureSet)

      tracker_storage = @storage

      ActiveRecord::FixtureSet.prepend(Module.new do
        define_method(:[]) do |fixture_name|
          if fixture_name
            tracker_storage[name] ||= Set.new
            tracker_storage[name].add(fixture_name.to_s)
          end
          super(fixture_name)
        end
      end)
    end
  end
end
