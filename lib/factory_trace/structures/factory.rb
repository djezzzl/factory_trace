# frozen_string_literal: true

module FactoryTrace
  module Structures
    class Factory
      include Helpers::Statusable

      attr_reader :names, :parent_name, :traits, :declaration_names, :definition_path

      # @param [Array<String>] names
      # @param [Array<FactoryTrace::Structure::Trait>] traits
      # @param [String|nil] parent_name
      # @param [Array<String>] declaration_names
      # @param [String] definition_path
      def initialize(names, traits, parent_name: nil, declaration_names: [], definition_path: nil)
        @names = names
        @traits = traits
        @parent_name = parent_name
        @declaration_names = declaration_names
        @definition_path = definition_path
      end

      # @return [Hash<Symbol, Object>]
      def to_h
        {
          names: names,
          traits: traits.map(&:to_h),
          parent_name: parent_name,
          declaration_names: declaration_names,
          definition_path: definition_path
        }
      end

      # Merge passed factory into self
      #
      # @param [FactoryTrace::Structures::Factory]
      def merge!(factory)
        factory.traits.each do |trait|
          traits << trait unless traits.any? { |t| t.name == trait.name }
        end
      end

      # @return [Boolean]
      def ==(other)
        return false unless other.is_a?(FactoryTrace::Structures::Factory)

        names == other.names &&
          traits == other.traits &&
          parent_name == other.parent_name &&
          declaration_names == other.declaration_names &&
          definition_path == other.definition_path
      end
    end
  end
end
