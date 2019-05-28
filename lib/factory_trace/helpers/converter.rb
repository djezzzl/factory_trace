module FactoryTrace
  module Helpers
    module Converter
      module_function

      # @param [FactoryBot::Trait] trait
      # @param [FactoryBot::Factory] owner
      #
      # @return [FactoryTrace::Structures::Trait]
      def trait(trait, owner = nil)
        FactoryTrace::Structures::Trait.new(
          trait.name.to_s,
          owner && owner.name.to_s
        )
      end

      # @param [FactoryBot::Factory] factory
      #
      # @return [FactoryTrace::Structures::Factory]
      def factory(factory)
        FactoryTrace::Structures::Factory.new(
          factory.name.to_s,
          factory.send(:parent).respond_to?(:name) ? factory.send(:parent).name.to_s : nil,
          factory.defined_traits.map(&:name).map(&:to_s),
          factory.instance_eval('@aliases').map(&:to_s)
        )
      end
    end
  end
end
