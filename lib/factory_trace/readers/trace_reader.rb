module FactoryTrace
  module Readers
    class TraceReader
      attr_reader :io, :configuration

      # Read the data from files and merge it
      #
      # @return [Hash<Symbol, FactoryTrace::Structures::Collection>]
      def self.read_from_files(*file_names, configuration: Configuration.new)
        result = {defined: FactoryTrace::Structures::Collection.new, used: FactoryTrace::Structures::Collection.new}

        file_names.each do |file_name|
          File.open(file_name, 'r') do |file|
            data = new(file, configuration: configuration).read

            [:defined, :used].each do |key|
              result[key].merge!(data[key])
            end
          end
        end

        result
      end

      def initialize(io, configuration: Configuration.new)
        @io = io
        @configuration = configuration
      end

      # Read the data from file
      #
      # @return [Hash<Symbol, FactoryTrace::Structures::Collection>]
      def read
        hash = JSON.parse(io.read)

        {
          defined: parse_collection(hash['defined']),
          used: parse_collection(hash['used'])
        }
      end

      private

      def parse_trait(hash)
        FactoryTrace::Structures::Trait.new(hash['name'], declaration_names: hash['declaration_names'])
      end

      def parse_factory(hash)
        FactoryTrace::Structures::Factory.new(
          hash['names'],
          hash['traits'].map(&method(:parse_trait)),
          parent_name: hash['parent_name'],
          declaration_names: hash['declaration_names']
        )
      end

      def parse_collection(hash)
        collection = FactoryTrace::Structures::Collection.new

        hash['factories'].each do |h|
          collection.add(parse_factory(h))
        end

        hash['traits'].each do |h|
          collection.add(parse_trait(h))
        end

        collection
      end
    end
  end
end
