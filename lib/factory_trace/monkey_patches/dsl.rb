# frozen_string_literal: true

module FactoryTrace
  module MonkeyPatches
    module Default
      module DSL
        def factory(name, options = {}, &block)
          caller_location = options.delete(:caller_location) || Helpers::Caller.location
          factory = FactoryBot::Factory.new(name, caller_location, options)
          proxy = FactoryBot::DefinitionProxy.new(factory.definition)
          proxy.instance_eval(&block) if block

          REGISTER.register_factory(factory)

          proxy.child_factories.each do |(child_name, child_caller_location, child_options, child_block)|
            parent_factory = child_options.delete(:parent) || name
            factory(child_name, child_options.merge(parent: parent_factory, caller_location: child_caller_location), &child_block)
          end
        end

        def trait(name, &block)
          REGISTER.register_trait(FactoryBot::Trait.new(name, Helpers::Caller.location, &block))
        end
      end
    end
  end
end
