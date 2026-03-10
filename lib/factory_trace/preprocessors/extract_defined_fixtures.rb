# frozen_string_literal: true

module FactoryTrace
  module Preprocessors
    class ExtractDefinedFixtures
      # Extracts all defined fixture sets and their entries from fixture YAML files
      #
      # @param [String, Array<String>] fixture_path path(s) to directories containing fixture YAML files
      #
      # @return [FactoryTrace::Structures::Collection]
      def self.call(fixture_path)
        collection = FactoryTrace::Structures::Collection.new

        Array(fixture_path).each do |path|
          Dir.glob(File.join(path, "**", "*.yml")).sort.each do |file|
            fixture_set_name = File.basename(file, ".yml")
            entries = parse_fixture_file(file)

            traits = entries.map do |entry_name, definition_path|
              FactoryTrace::Structures::Trait.new(entry_name, definition_path: definition_path)
            end

            factory = FactoryTrace::Structures::Factory.new(
              [fixture_set_name],
              traits,
              definition_path: "#{file}:1"
            )

            collection.add(factory)
          end
        end

        collection
      end

      # Parses a fixture YAML file and returns a hash of entry names to definition paths
      #
      # @param [String] file_path
      #
      # @return [Hash<String, String>]
      def self.parse_fixture_file(file_path)
        entries = {}
        lineno = 1

        File.foreach(file_path) do |line|
          if (match = line.match(/\A(\w+):(?:\s|$)/))
            entries[match[1]] = "#{file_path}:#{lineno}"
          end
          lineno += 1
        end

        entries
      end

      private_class_method :parse_fixture_file
    end
  end
end
