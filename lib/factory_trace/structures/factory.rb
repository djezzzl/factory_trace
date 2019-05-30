module FactoryTrace
  module Structures
    class Factory
      attr_reader :name, :parent_name, :trait_names, :alias_names

      # @param [String] name
      # @param [String, nil] parent_name
      # @param [Array<String>] trait_names
      def initialize(name, parent_name, trait_names, alias_names = [])
        @name = name
        @parent_name = parent_name
        @trait_names = trait_names
        @alias_names = alias_names
      end

      # @return [Hash<Symbol, String>]
      def to_h
        {
          name: name,
          alias_names: alias_names,
          parent_name: parent_name,
          trait_names: trait_names
        }
      end

      # Merge passed factory into self
      #
      # @param [FactoryTrace::Structures::Factory]
      #
      # @return [FactoryTrace::Structures::Factory]
      def merge!(factory)
        @trait_names = (trait_names + factory.trait_names).uniq
      end

      # @return [Boolean]
      def ==(factory)
        return false unless factory.is_a?(FactoryTrace::Structures::Factory)

        (name == factory.name || alias_names == factory.alias_names) &&
          parent_name == factory.parent_name &&
          trait_names == factory.trait_names
      end
    end
  end
end
