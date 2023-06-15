# frozen_string_literal: true

module FactoryTrace
  module MonkeyPatches
    module Trait
      attr_reader :definition_path

      def initialize(name, definition_path = "", &block)
        @definition_path = definition_path
        super(name, &block)
      end
    end
  end
end
