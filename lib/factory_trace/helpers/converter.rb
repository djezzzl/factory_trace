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
          declaration_names: trait.definition.declarations.grep(FactoryBot::Declaration::Implicit).map(&:name).map(&:to_s)
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
          declaration_names: factory.definition.declarations.grep(FactoryBot::Declaration::Implicit).map(&:name).map(&:to_s)
        )
      end
    end
  end
end
