module FactoryTrace
  module Preprocessors
    class ExtractUsed
      # Returns a collection with used factories and traits gathered from trace
      #
      # @param [Hash<String, Set<String>>]
      #
      # @return [FactoryTrace::Structures::Collection]
      def self.call(trace)
        collection = FactoryTrace::Structures::Collection.new

        trace.each do |factory_name, factory_data|
          traits = factory_data[:traits].to_a
          alias_names = factory_data[:alias_names].to_a

          collection.add(FactoryTrace::Structures::Factory.new(factory_name, nil, traits, alias_names))
        end

        collection
      end
    end
  end
end
