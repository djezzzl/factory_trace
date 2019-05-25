module FactoryTrace
  module Structures
    class Factory
      attr_reader :name, :parent_name, :trait_names

      # @param [String] name
      # @param [String, nil] parent_name
      # @param [Array<String>] trait_names
      def initialize(name, parent_name, trait_names)
        @name = name
        @parent_name = parent_name
        @trait_names = trait_names
      end

      # @return [Hash<Symbol, String>]
      def to_h
        {
          name: name,
          parent_name: parent_name,
          trait_names: trait_names
        }
      end

      # @return [Boolean]
      def ==(factory)
        return false unless factory.is_a?(FactoryTrace::Structures::Factory)

        name == factory.name && parent_name == factory.parent_name && trait_names == factory.trait_names
      end
    end
  end
end
