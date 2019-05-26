module FactoryTrace
  module Processors
    class FindUnused
      # Finds unused factories and traits
      #
      # @param [FactoryTrace::Structures::Collection] defined
      # @param [FactoryTrace::Structures::Collection] used
      #
      # @return [Array<Hash>]
      def self.call(defined, used)
        used_inherited_traits = used_inherited_traits(defined, used)
        used_child_factories = used_child_factories(defined, used)

        output = []

        defined.factories.each_value do |factory|
          unless used.factories[factory.name]
            if used_child_factories[factory.name]
              output << {code: :used_indirectly, factory_name: factory.name, child_factories_names: used_child_factories[factory.name]}
            else
              output << {code: :unused, factory_name: factory.name}
            end
          end

          factory.trait_names.each do |trait_name|
            unless trait_used?(used, factory.name, trait_name) || trait_used?(used_inherited_traits, factory.name, trait_name)
              output << {code: :unused, factory_name: factory.name, trait_name: trait_name}
            end
          end
        end

        defined.traits.each_value do |trait|
          unless used_inherited_traits.traits[trait.name]
            output << {code: :unused, trait_name: trait.name}
            next
          end
        end

        unused_count = output.count { |result| result[:code] == :unused }
        used_indirectly_count = output.count { |result| result[:code] == :used_indirectly }

        output.unshift(code: :unused, value: unused_count)
        output.unshift(code: :used_indirectly, value: used_indirectly_count)
        output.unshift(code: :used, value: defined.total - unused_count - used_indirectly_count)

        output
      end

      private

      # Checks if factory of the collection contains a trait
      #
      # @param [FactoryTrace::Structures::Collection] collection
      # @param [String] factory_name
      # @param [String] trait_name
      #
      # @return [Boolean]
      def self.trait_used?(collection, factory_name, trait_name)
        collection.factories[factory_name] && collection.factories[factory_name].trait_names.include?(trait_name)
      end

      # Returns a new collection where traits which were used moved to their owner factory
      #
      # @param [FactoryTrace::Structures::Collection] defined
      # @param [FactoryTrace::Structures::Collection] used
      #
      # @return [FactoryTrace::Structures::Collection]
      def self.used_inherited_traits(defined, used)
        collection = FactoryTrace::Structures::Collection.new

        used.factories.each_value do |factory|
          factory.trait_names.each do |trait_name|
            possible_owner_name = factory.name

            while possible_owner_name
              break if defined.factories[possible_owner_name].trait_names.include?(trait_name)
              possible_owner_name = defined.factories[possible_owner_name].parent_name
            end

            if possible_owner_name
              factory = collection.factories[possible_owner_name]
              factory ||= collection.add(FactoryTrace::Structures::Factory.new(possible_owner_name, nil, []))

              factory.trait_names << trait_name unless factory.trait_names.include?(trait_name)
            else
              collection.add(FactoryTrace::Structures::Trait.new(trait_name, nil))
            end
          end
        end

        collection
      end

      # Returns a hash:
      # - key is factory name
      # - value is factory names which where used and are children of the factory
      #
      # @param [FactoryTrace::Structures::Collection] defined
      # @param [FactoryTrace::Structures::Collection] used
      #
      # @return [Hash<String, Array<String>]
      def self.used_child_factories(defined, used)
        hash = {}

        used.factories.each_value do |factory|
          parent_name = defined.factories[factory.name].parent_name

          if parent_name
            hash[parent_name] ||= []
            hash[parent_name] << factory.name
          end
        end

        hash
      end
    end
  end
end
