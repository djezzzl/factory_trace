module FactoryTrace
  module Helpers
    module Converter
      module_function

      # @param [FactoryBot::Trait] trait
      #
      # @return [FactoryTrace::Structures::Trait]
      def trait(trait)
        FactoryTrace::Structures::Trait.new(
          trait.name.to_s,
          declaration_names: extract_declarations(trait),
          definition_path: (trait.definition_path if trait.respond_to?(:definition_path))
        )
      end

      # @param [FactoryBot::Factory] factory
      #
      # @return [FactoryTrace::Structures::Factory]
      def factory(factory)
        FactoryTrace::Structures::Factory.new(
          factory.names.map(&:to_s),
          factory.defined_traits.map(&method(:trait)),
          parent_name: factory.send(:parent).respond_to?(:name) ? factory.send(:parent).name.to_s : nil,
          declaration_names: extract_declarations(factory),
          definition_path: (factory.definition_path if factory.respond_to?(:definition_path))
        )
      end

      # @param [FactoryBot::Factory|FactoryBot::Trait]
      #
      # @return [Array<String>]
      def extract_declarations(structure)
        (structure.definition.declarations.grep(FactoryBot::Declaration::Implicit).map(&:name).map(&:to_s) +
          structure.definition.instance_variable_get(:'@base_traits').map(&:to_s)).uniq
      end
    end
  end
end
