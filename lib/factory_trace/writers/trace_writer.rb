# frozen_string_literal: true

module FactoryTrace
  module Writers
    class TraceWriter < Writer
      # @param [Hash] defined
      # @param [Hash] used
      def write(defined, used)
        io.puts(JSON.pretty_generate(defined: defined.to_h, used: used.to_h))
      end
    end
  end
end
