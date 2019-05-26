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

      # Merge passed collection into self
      #
      # @param [FactoryTrace::Structures::Collection]
      #
      # @return [FactoryTrace::Structures::Collection]
      def merge!(collection)
        collection.factories.each_value do |factory|
          if factories[factory.name]
            factories[factory.name].merge!(factory)
          else
            add(FactoryTrace::Structures::Factory.new(factory.name, factory.parent_name, factory.trait_names))
          end
        end

        collection.traits.each_value do |trait|
          add(FactoryTrace::Structures::Trait.new(trait.name, trait.owner_name)) unless traits[trait.name]
        end
      end

      # @return [Hash]
      def to_h
        {
          factories: convert(factories),
          traits: convert(traits)
        }
      end

      # Total number of factories and traits
      #
      # @return [Integer]
      def total
        traits.size + factories.size + factories.values.sum { |factory| factory.trait_names.size }
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

      # @return [Hash]
      def convert(hash)
        hash.each_value.map(&:to_h)
      end
    end
  end
end
