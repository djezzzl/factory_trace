# frozen_string_literal: true

require "bundler/setup"
require "factory_trace"

require "tempfile"

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  config.include FactoryBot::Syntax::Methods

  config.before(:suite) do
    FactoryBot.find_definitions
  end

  def find_factory(name)
    FactoryBot.factories[name.to_s]
  end

  def find_trait(factory_name, trait_name)
    FactoryBot.factories[factory_name.to_s].defined_traits.find { |trait| trait.name.to_s == trait_name.to_s }
  end

  def find_global_trait(name)
    FactoryTrace::MonkeyPatches::REGISTER.traits[name.to_s]
  end
end
