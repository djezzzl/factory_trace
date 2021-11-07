# frozen_string_literal: true

RSpec.configure do |config|
  config.before(:suite) { FactoryTrace.start }
  config.after(:suite) { FactoryTrace.stop }
end
