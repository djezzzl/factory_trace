module FactoryTrace
  module Helpers
    module Caller
      module_function

      # @return [String] file and line where the original method was called
      def location
        location = caller_locations[1]
        "#{location.absolute_path}:#{location.lineno}"
      end
    end
  end
end
