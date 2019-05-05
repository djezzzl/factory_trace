require 'set'

module FactoryTrace
  class StorageHandler
    # @param [Hash<Symbol, Set<Symbol>>] initial_data
    #
    # First hash - all factories
    # Second hash - used factories
    #
    # @return [Array<Hash>]
    def self.prepare(initial_data)
      [collect_all, convert(initial_data)]
    end

    private

    def self.collect_all
      FactoryBot.factories.reduce({'_traits' => Set.new(FactoryBot.traits.map(&:name).map(&:to_s))}) do |hash, factory|
        hash[factory.name.to_s] = Set.new(factory.defined_traits.map(&:name).map(&:to_s))
        hash
      end
    end

    # Return new structure where each trait is moved to its own factory
    #
    # @param [Hash<Symbol, Set<Symbol>>]
    # @return [Hash<String, Set<String>>]
    def self.convert(data)
      # +_traits+ is for global traits
      output = {'_traits' => Set.new}

      data.each do |factory_name, trait_names|
        factory_name = factory_name.to_s

        output[factory_name] ||= Set.new

        trait_names.each do |trait_name|
          trait_name = trait_name.to_s

          factory = FactoryBot.factories[factory_name]
          trait_found = false

          until factory.is_a?(FactoryBot::NullFactory)
            if factory.defined_traits.any? { |trait| trait.name.to_s == trait_name }
              trait_found = true
              output[factory.name.to_s] ||= Set.new
              output[factory.name.to_s] << trait_name
              break
            end
            factory = factory.send(:parent)
          end

          # Belongs to global traits
          output['_traits'] << trait_name unless trait_found
        end
      end

      output
    end
  end
end
