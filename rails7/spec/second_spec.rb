# frozen_string_literal: true

require "rails_helper"

RSpec.describe "second spec" do # rubocop:disable RSpec/DescribeClass
  it "tests" do # rubocop:disable RSpec/NoExpectationExample
    build(:special_user, :with_phone)
  end
end
