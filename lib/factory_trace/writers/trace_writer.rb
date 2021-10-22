# frozen_string_literal: true

module FactoryTrace
  module Writers
    class TraceWriter < Writer
      # @param [FactoryTrace::Structures::Collection] defined
      # @param [FactoryTrace::Structures::Collection] used
      def write(defined, used)
        io.puts(JSON.pretty_generate(defined: defined.to_h, used: used.to_h))
      end
    end
  end
end
