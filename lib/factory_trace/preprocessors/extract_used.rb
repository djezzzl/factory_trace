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

        trace.each do |factory_name, trait_names|
          collection.add(FactoryTrace::Structures::Factory.new(factory_name, nil, trait_names.to_a))
        end

        collection
      end
    end
  end
end
