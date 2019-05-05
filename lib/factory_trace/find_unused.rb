module FactoryTrace
  class FindUnused
    # @param [Array<Hash>] initial_data
    # @return [Array<Hash>]
    def self.call(initial_data)
      all, used = initial_data

      output = []

      all.each do |factory_name, trait_names|
        unless used.key?(factory_name)
          output << {code: :unused, factory_name: factory_name}
          next
        end

        trait_names.each do |trait_name|
          unless used[factory_name].include?(trait_name)
            output << {code: :unused, trait_name: trait_name}.tap { |h| h[:factory_name] = factory_name unless factory_name == '_traits' }
          end
        end
      end

      output.unshift(code: :unused, value: output.size)
      output.unshift(code: :used, value: count_total(used))

      output
    end

    private

    # @param [Hash<Symbol, Set<Symbol>>]
    def self.count_total(data)
      data.reduce(0) { |result, (factory_name, trait_names)| result + (factory_name != '_traits' ? 1 : 0) + trait_names.size }
    end
  end
end
