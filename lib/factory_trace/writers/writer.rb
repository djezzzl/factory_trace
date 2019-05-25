module FactoryTrace
  module Writers
    class Writer
      attr_reader :configuration

      def initialize(configuration)
        @configuration = configuration
      end
    end
  end
end
