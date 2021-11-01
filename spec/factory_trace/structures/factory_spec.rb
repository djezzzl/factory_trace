# frozen_string_literal: true

RSpec.describe FactoryTrace::Structures::Factory do
  subject(:factory) { described_class.new(names, traits, **opts) }

  let(:names) { ["user", "person"] }
  let(:traits) { [FactoryTrace::Structures::Trait.new("special")] }
  let(:opts) { {} }

  describe "#to_h" do
    subject(:hash) { factory.to_h }

    specify do
      expect(hash).to eq({
        names: ["user", "person"],
        traits: [{name: "special", declaration_names: [], definition_path: nil}],
        parent_name: nil,
        declaration_names: [],
        definition_path: nil
      })
    end
  end
end
