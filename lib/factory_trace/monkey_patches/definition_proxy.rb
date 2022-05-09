# frozen_string_literal: true

module FactoryTrace
  module MonkeyPatches
    module DefinitionProxy
      def factory(name, options = {}, &block)
        @child_factories << [name, Helpers::Caller.location, options, block]
      end

      def trait(name, &block)
        @definition.define_trait(FactoryBot::Trait.new(name, Helpers::Caller.location, &block))
      end

      def traits_for_enum(name, values = nil)
        @definition.register_enum(FactoryBot::Enum.new(name, Helpers::Caller.location, values))
      end
    end
  end
end
