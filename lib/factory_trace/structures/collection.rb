module FactoryTrace
  module Structures
    class Collection
      attr_reader :factories, :traits

      # @param [Hash<String, FactoryTrace::Structures::Factory>]
      # @param [Hash<String, FactoryTrace::Structures::Trait>]
      def initialize(factories = {}, traits = {})
        @factories = factories
        @traits = traits
      end

      # @param [FactoryTrace::Structures::Factory, FactoryTrace::Structures::Trait] element
      #
      # @return [FactoryTrace::Structures::Factory, FactoryTrace::Structures::Trait]
      def add(element)
        case element
        when FactoryTrace::Structures::Factory then store(factories, element)
        when FactoryTrace::Structures::Trait then store(traits, element)
        else
          fail "Unknown element: #{element.inspect}"
        end
      end

      # @return [Hash]
      def to_h
        {
          factories: factories.map(&:to_h),
          traits: traits.map(&:to_h)
        }
      end

      # @return [Boolean]
      def ==(collection)
        return false unless collection.is_a?(FactoryTrace::Structures::Collection)

        factories == collection.factories && traits == collection.traits
      end

      private

      # @param [Hash] hash
      # @param [FactoryTrace::Structures::Factory, FactoryTrace::Structures::Trait] element
      #
      # @return [FactoryTrace::Structures::Factory, FactoryTrace::Structures::Trait] element
      def store(hash, element)
        hash[element.name] = element
      end
    end
  end
end
