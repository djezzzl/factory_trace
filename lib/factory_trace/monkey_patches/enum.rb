# frozen_string_literal: true

module FactoryTrace
  module MonkeyPatches
    module Enum
      attr_reader :definition_path

      def initialize(name, definition_path, values = nil)
        @definition_path = definition_path
        super(name, values)
      end

      private

      def build_trait(trait_name, attribute_name, value)
        ::FactoryBot::Trait.new(trait_name, definition_path) do
          add_attribute(attribute_name) { value }
        end
      end
    end
  end
end
