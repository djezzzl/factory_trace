# frozen_string_literal: true

RSpec.describe FactoryTrace::Structures::Trait do
  subject(:trait) { described_class.new(name) }

  let(:name) { "something" }

  describe "#to_h" do
    subject { trait.to_h }

    it { is_expected.to eq({name: "something", declaration_names: [], definition_path: nil}) }
  end
end
