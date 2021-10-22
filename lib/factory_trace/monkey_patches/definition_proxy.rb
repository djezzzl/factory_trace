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
    end
  end
end
