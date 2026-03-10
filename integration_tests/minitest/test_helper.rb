# frozen_string_literal: true

require "bundler/setup"
require "minitest/autorun"
require "factory_trace"

FactoryBot.find_definitions

class Minitest::Test
  include FactoryBot::Syntax::Methods
end
