# frozen_string_literal: true

require_relative "test_helper"

class IntegrationTest < Minitest::Test
  def test_uses_some
    build(:admin)
  end
end
