module FactoryTrace
  class FindUnused
    # @param [Hash<Symbol, Set<Symbol>>] initial_data
    # @return [Array<Hash>]
    def self.call(initial_data)
      # This is required to exclude parent traits from +defined_traits+
      FactoryBot.reload

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

      output.unshift(code: :unused, value: output.size)
      output.unshift(code: :used, value: data['_total_used'])
    end

    private

    # Return new structure where each trait is moved to its own factory
    #
    # @param [Hash<Symbol, Set<Symbol>>]
    # @return [Hash<String, Set<String>>]
    def self.prepare(data)
      # +_traits+ is for global traits
      output = {'_traits' => Set.new, '_total_used' => count_total(data)}

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

    # @param [Hash<Symbol, Set<Symbol>>]
    def self.count_total(data)
      data.reduce(0) { |result, (_factory, traits)| result + 1 + traits.size }
    end
  end
end
