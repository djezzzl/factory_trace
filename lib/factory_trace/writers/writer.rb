# frozen_string_literal: true

module FactoryTrace
  module Writers
    class Writer
      attr_reader :io, :configuration

      def initialize(io, configuration = Configuration.new)
        @io = io
        @configuration = configuration
      end

      def file?
        io.is_a?(File)
      end
    end
  end
end
