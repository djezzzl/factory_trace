# frozen_string_literal: true

RSpec.describe FactoryTrace::Structures::Collection do
  subject(:collection) { described_class.new(factories, traits) }

  let(:factories) { [] }
  let(:traits) { [] }

  describe "#to_h" do
    subject { collection.to_h }

    it { is_expected.to eq({factories: [], traits: []}) }
  end

  describe "#add" do
    subject { collection.add(element) }

    context "when element is a factory" do
      let(:element) { FactoryTrace::Structures::Factory.new(["name"], []) }

      specify do
        expect(subject).to eq(element)
        expect(collection.factories).to eq([element])
      end
    end

    context "when element is a trait" do
      let(:element) { FactoryTrace::Structures::Trait.new("name") }

      specify do
        expect(subject).to eq(element)
        expect(collection.traits).to eq([element])
      end
    end
  end

  describe "#total" do
    subject { collection.total }

    it { is_expected.to eq(0) }
  end
end
