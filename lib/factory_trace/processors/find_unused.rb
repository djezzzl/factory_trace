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
        output = []

        defined.factories.each_value do |factory|
          unless used.factories[factory.name]
            output << {code: :unused, factory_name: factory.name}
            next
          end

          factory.trait_names.each do |trait_name|
            unless used.factories[factory.name].trait_names.include?(trait_name)
              output << {code: :unused, factory_name: factory.name, trait_name: trait_name}
            end
          end
        end

        defined.traits.each_value do |trait|
          unless used.traits[trait.name]
            output << {code: :unused, trait_name: trait.name}
            next
          end
        end

        unused_count = output.size
        output.unshift(code: :unused, value: unused_count)
        output.unshift(code: :used, value: defined.total - unused_count)

        output
      end
    end
  end
end
