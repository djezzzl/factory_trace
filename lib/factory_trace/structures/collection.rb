module FactoryTrace
  module Structures
    class Collection
      attr_reader :factories, :traits

      # @param [Array<String, FactoryTrace::Structures::Factory>]
      # @param [Array<String, FactoryTrace::Structures::Trait>]
      def initialize(factories = [], traits = [])
        @factories = factories
        @traits = traits
      end

      # @param [FactoryTrace::Structures::Factory, FactoryTrace::Structures::Trait] element
      #
      # @return [FactoryTrace::Structures::Factory, FactoryTrace::Structures::Trait]
      def add(element)
        case element
        when FactoryTrace::Structures::Factory then factories << element
        when FactoryTrace::Structures::Trait then traits << element
        else
          fail "Unknown element: #{element.inspect}"
        end

        element
      end

      # @param [Array<String>] names
      #
      # @return [FactoryTrace::Structures::Factory|nil]
      def find_factory_by_names(*names)
        factories.find { |factory| names.include?(factory.name) || (names & factory.alias_names).size > 0 }
      end

      # @param [Array<String>] names
      #
      # @return [FactoryTrace::Structures::Trait|nil]
      def find_trait_by_names(*names)
        traits.find { |trait| names.include?(trait.name) }
      end

      # @param [FactoryTrace::Structures::Factory|FactoryTrace::Structures::Trait]
      #
      # @return [FactoryTrace::Structures::Factory|FactoryTrace::Structures::Trait]
      def find(element)
        case element
        when FactoryTrace::Structures::Factory then find_factory_by_names(element.name, *element.alias_names)
        when FactoryTrace::Structures::Trait then find_trait_by_names(element.name)
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
        collection.factories.each do |factory|
          if (persisted = find(factory))
            persisted.merge!(factory)
          else
            add(FactoryTrace::Structures::Factory.new(factory.name, factory.parent_name, factory.trait_names, factory.alias_names))
          end
        end

        collection.traits.each do |trait|
          add(FactoryTrace::Structures::Trait.new(trait.name, trait.owner_name)) unless find(trait)
        end
      end

      # @return [Hash]
      def to_h
        {
          factories: factories.map(&:to_h),
          traits: traits.map(&:to_h)
        }
      end

      # Total number of factories and traits
      #
      # @return [Integer]
      def total
        traits.size + factories.size + factories.sum { |factory| factory.trait_names.size }
      end

      # @return [Boolean]
      def ==(collection)
        return false unless collection.is_a?(FactoryTrace::Structures::Collection)

        factories == collection.factories && traits == collection.traits
      end
    end
  end
end
