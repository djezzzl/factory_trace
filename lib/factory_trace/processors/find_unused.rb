# frozen_string_literal: true

module FactoryTrace
  module Processors
    class FindUnused
      class << self
        # Finds unused factories and traits
        #
        # @param [FactoryTrace::Structures::Collection] defined
        # @param [FactoryTrace::Structures::Collection] used
        #
        # @return [Array<Hash>]
        def call(defined, used)
          mark_as_used(defined, used)

          output = []

          defined.factories.each do |factory|
            output << append_definition_path({code: :unused, factory_names: factory.names}, factory) unless factory.status

            factory.traits.each do |trait|
              output << append_definition_path({code: :unused, factory_names: factory.names, trait_name: trait.name}, trait) unless trait.status
            end
          end

          defined.traits.each do |trait|
            output << append_definition_path({code: :unused, trait_name: trait.name}, trait) unless trait.status
          end

          output.unshift(code: :unused, value: output.size)
          output.unshift(code: :used, value: defined.total - (output.size - 1))

          output
        end

        private

        # @param [FactoryTrace::Structures::Collection] defined
        # @param [FactoryTrace::Structures::Collection] used
        def mark_as_used(defined, used)
          used.factories.each do |used_factory|
            defined_factory = defined.find_factory_by_names(used_factory.names)
            mark_factory(defined_factory, defined, status: :used)

            used_factory.traits.each do |used_trait|
              trait_owner, defined_trait = defined_trait_by_name(defined, used_factory, used_trait.name)
              mark_trait(defined_trait, trait_owner, defined, status: :used)
            end
          end
        end

        # @param [FactoryTrace::Structures::Collection] defined
        # @param [FactoryTrace::Structures::Factory|nil] factory
        # @param [String] trait_name
        #
        # @return [Array<Object>]
        def defined_trait_by_name(defined, factory, trait_name)
          if factory
            possible_owner = defined.find_factory_by_names(factory.names)

            while possible_owner
              if (trait = possible_owner.traits.find { |t| t.name == trait_name })
                return [possible_owner, trait]
              end
              possible_owner = defined.find_factory_by_names([possible_owner.parent_name])
            end
          end

          [nil, defined.find_trait_by_name(trait_name)]
        end

        # @param [FactoryTrace::Structures::Factory, nil] factory
        # @param [FactoryTrace::Structures::Collection] collection
        # @param [Symbol] status
        def mark_factory(factory, collection, status:)
          return if factory.nil? || factory.has_prioritized_status?(status)

          factory.status = status
          if (parent = collection.find_factory_by_names([factory.parent_name]))
            mark_factory(parent, collection, status: :indirectly_used)
          end
          mark_declarations(factory.declaration_names, factory, collection, status: :indirectly_used)
        end

        # @param [FactoryTrace::Structures::Trait, nil] trait
        # @param [FactoryTrace::Structures::Factory|nil] factory which trait belongs to
        # @param [FactoryTrace::Structures::Collection] collection
        # @param [Symbol] status
        def mark_trait(trait, factory, collection, status:)
          return if trait.nil? || trait.has_prioritized_status?(status)

          trait.status = status
          mark_declarations(trait.declaration_names, factory, collection, status: :indirectly_used)
        end

        # @param [Array<String>] declaration_names
        # @param [FactoryTrace::Structures::Factory|nil] factory
        # @param [FactoryTrace::Structures::Collection] collection
        # @param [Symbol] status
        def mark_declarations(declaration_names, factory, collection, status:)
          declaration_names.each do |declaration_name|
            declaration_factory = collection.find_factory_by_names([declaration_name])
            next mark_factory(declaration_factory, collection, status: status) if declaration_factory

            declaration_factory, declaration_trait = defined_trait_by_name(collection, factory, declaration_name)
            mark_trait(declaration_trait, declaration_factory, collection, status: status) if declaration_trait
          end
        end

        # @param [Hash]
        # @param [FactoryTrace::Structures::Factory|FactoryTrace::Structures::Trait]
        #
        # @return [Hash]
        def append_definition_path(hash, object)
          hash[:definition_path] = object.definition_path if object.definition_path
          hash
        end
      end
    end
  end
end
