# frozen_string_literal: true

Minitest.after_run { FactoryTrace.stop }

module Minitest
  class << self
    prepend(Module.new do
      def run(args = [])
        FactoryTrace.start
        super
      end
    end)
  end
end
