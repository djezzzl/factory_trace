# frozen_string_literal: true

Minitest.after_run { FactoryTrace.stop }
FactoryTrace.start
