module FactoryTrace
  module Helpers
    module Statusable
      PRIORITY_ORDER = [:used, :indirectly_used, nil]

      attr_reader :status

      def status=(status)
        @status = status unless has_prioritized_status?(status)
      end

      def has_prioritized_status?(status)
        PRIORITY_ORDER.index(@status) <= PRIORITY_ORDER.index(status)
      end
    end
  end
end
