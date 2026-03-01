# frozen_string_literal: true

require_relative "test_helper"

class FactoryTraceTest < Minitest::Test
  include FactoryBot::Syntax::Methods

  def test_uses_some
    build(:admin)
  end
end
