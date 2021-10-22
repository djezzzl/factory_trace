# frozen_string_literal: true

module FactoryTrace
  module Preprocessors
    class ExtractDefined
      # @return [FactoryTrace::Structures::Collection]
      def self.call
        collection = FactoryTrace::Structures::Collection.new

        MonkeyPatches::REGISTER.traits.each do |trait|
          collection.add(FactoryTrace::Helpers::Converter.trait(trait))
        end

        FactoryBot.factories.each do |factory|
          collection.add(FactoryTrace::Helpers::Converter.factory(factory))
        end

        collection
      end
    end
  end
end
