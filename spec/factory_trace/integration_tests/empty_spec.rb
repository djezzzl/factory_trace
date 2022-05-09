# frozen_string_literal: true

RSpec.describe FactoryTrace do
  it "uses nothing" do
    build(:task, :queued)
  end
end
