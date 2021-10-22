# frozen_string_literal: true

module FactoryTrace
  module Structures
    class Trait
      include Helpers::Statusable

      attr_reader :name, :declaration_names, :definition_path

      # @param [String] name
      # @param [Array<String>] declaration_names
      # @param [String] definition_path
      def initialize(name, declaration_names: [], definition_path: nil)
        @name = name
        @declaration_names = declaration_names
        @definition_path = definition_path
      end

      # @return [Hash<Symbol, Object>]
      def to_h
        {
          name: name,
          declaration_names: declaration_names,
          definition_path: definition_path
        }
      end

      # @return [Boolean]
      def ==(trait)
        return false unless trait.is_a?(FactoryTrace::Structures::Trait)

        name == trait.name && declaration_names == trait.declaration_names && definition_path == trait.definition_path
      end
    end
  end
end
