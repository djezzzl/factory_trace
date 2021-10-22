# frozen_string_literal: true

module FactoryTrace
  module Helpers
    module Caller
      module_function

      # @return [String] file and line where the original method was called
      def location
        location = caller_locations(2..2).first

        base = Pathname.new(Dir.pwd)
        method = Pathname.new(location.path)

        "#{method.relative_path_from(base)}:#{location.lineno}"
      end
    end
  end
end
