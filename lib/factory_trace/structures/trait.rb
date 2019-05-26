module FactoryTrace
  module Structures
    class Trait
      include Helpers::Statusable

      attr_reader :name, :declaration_names

      # @param [String] name
      # @param [Array<String>] declaration_names
      def initialize(name, declaration_names: [])
        @name = name
        @declaration_names = declaration_names
      end

      # @return [Hash<Symbol, Object>]
      def to_h
        {
          name: name,
          declaration_names: declaration_names
        }
      end

      # @return [Boolean]
      def ==(trait)
        return false unless trait.is_a?(FactoryTrace::Structures::Trait)

        name == trait.name && declaration_names == trait.declaration_names
      end
    end
  end
end
