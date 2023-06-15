# frozen_string_literal: true

module FactoryTrace
  module MonkeyPatches
    module Factory
      attr_reader :definition_path

      def initialize(name, definition_path = "", options = {})
        @definition_path = definition_path
        super(name, options)
      end
    end
  end
end
