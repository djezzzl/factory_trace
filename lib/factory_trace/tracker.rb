module FactoryTrace
  class Tracker
    attr_reader :storage

    def initialize
      @storage = {}
    end

    def track!
      ActiveSupport::Notifications.subscribe("factory_bot.run_factory") do |_name, _start, _finish, _id, payload|
        name = payload[:name].to_s
        traits = payload[:traits].map(&:to_s)

        storage[name] ||= Set.new
        storage[name] |= traits
      end
    end
  end
end
