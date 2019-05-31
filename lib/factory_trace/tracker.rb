module FactoryTrace
  class Tracker
    attr_reader :storage

    def initialize
      @storage = {}
    end

    def track!
      ActiveSupport::Notifications.subscribe('factory_bot.run_factory') do |_name, _start, _finish, _id, payload|
        name = payload[:factory].name.to_s
        traits = payload[:traits].map(&:to_s)
        alias_names = payload[:factory].names.map(&:to_s) - [name]

        storage[name] ||= { traits: Set.new, alias_names: Set.new }
        storage[name][:traits] |= traits
        storage[name][:alias_names] |= alias_names
      end
    end
  end
end
