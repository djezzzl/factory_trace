# frozen_string_literal: true

require "rails_helper"

RSpec.describe "first spec" do # rubocop:disable RSpec/DescribeClass
  it "tests" do # rubocop:disable RSpec/NoExpectationExample
    build(:special_user)
  end
end
