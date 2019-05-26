module FactoryTrace
  module Structures
    class Trait
      attr_reader :name, :owner_name

      # @param [String] name
      # @param [String, nil] owner_name
      def initialize(name, owner_name)
        @name = name
        @owner_name = owner_name
      end

      # @return [Hash<Symbol, String>]
      def to_h
        {
          name: name,
          owner_name: owner_name
        }
      end

      # @return [Boolean]
      def ==(trait)
        return false unless trait.is_a?(FactoryTrace::Structures::Trait)

        name == trait.name && owner_name == trait.owner_name
      end
    end
  end
end
