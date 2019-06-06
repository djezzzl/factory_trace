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
          traits = trait_names.map { |trait_name| FactoryTrace::Structures::Trait.new(trait_name) }
          factory = FactoryTrace::Structures::Factory.new([factory_name], traits)

          collection.add(factory)
        end

        collection
      end
    end
  end
end
