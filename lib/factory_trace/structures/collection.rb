# frozen_string_literal: true

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

      # @param [FactoryTrace::Structures::Factory|FactoryTrace::Structures::Trait] element
      #
      # @return [FactoryTrace::Structures::Factory|FactoryTrace::Structures::Trait]
      def add(element)
        case element
        when FactoryTrace::Structures::Factory then factories << element
        when FactoryTrace::Structures::Trait then traits << element
        end

        element
      end

      # @param [Array<String>] names
      #
      # @return [FactoryTrace::Structures::Factory|nil]
      def find_factory_by_names(names)
        factories.find { |factory| (names & factory.names).size > 0 }
      end

      # @param [String] name
      #
      # @return [FactoryTrace::Structures::Trait|nil]
      def find_trait_by_name(name)
        traits.find { |trait| name == trait.name }
      end

      # @return [Hash]
      def to_h
        {
          factories: factories.map(&:to_h),
          traits: traits.map(&:to_h)
        }
      end

      # Merge passed collection into self
      #
      # @param [FactoryTrace::Structures::Collection]
      def merge!(collection)
        collection.factories.each do |factory|
          if (persisted = find_factory_by_names(factory.names))
            persisted.merge!(factory)
          else
            add(factory)
          end
        end

        collection.traits.each do |trait|
          add(trait) unless find_trait_by_name(trait.name)
        end
      end

      # Total number of factories and traits
      #
      # @return [Integer]
      def total
        traits.size + factories.size + factories.sum { |factory| factory.traits.size }
      end

      # @return [Boolean]
      def ==(collection)
        return false unless collection.is_a?(FactoryTrace::Structures::Collection)

        factories == collection.factories && traits == collection.traits
      end
    end
  end
end
