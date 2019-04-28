module FactoryTrace
  class CheckUnused

    # @param [Hash<Symbol, Set<Symbol>>]
    def initialize(data)
      @initial_data = data
    end

    # @return [Array<Hash>]
    def check!
      data = prepare(initial_data)

      output = []

      FactoryBot.factories.each do |factory|
        unless data[factory.name.to_s]
          output << {code: :unused, factory: factory}
          next
        end

        factory.defined_traits.each do |trait|
          output << {code: :unused, factory: factory, trait: trait} unless data[factory.name.to_s].include?(trait.name.to_s)
        end
      end

      FactoryBot.traits.each do |trait|
        output << {code: :unused, trait: trait} unless data['_traits'].include?(trait.name.to_s)
      end

      output
    end

    private

    # Return new structure where each trait is moved to its own factory
    #
    # @param [Hash<Symbol, Set<Symbol>>]
    #
    # @return [Hash<String, Set<String>>]
    def prepare(data)
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

    attr_reader :initial_data
  end
end
