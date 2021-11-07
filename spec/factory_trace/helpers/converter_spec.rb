# frozen_string_literal: true

RSpec.describe FactoryTrace::Helpers::Converter do
  describe ".trait" do
    subject(:structure) { described_class.trait(trait) }

    let(:trait) { find_global_trait("with_address") }

    specify do
      expect(structure).to eq(FactoryTrace::Structures::Trait.new("with_address"))
    end
  end

  describe ".factory" do
    subject(:structure) { described_class.factory(factory) }

    context "when has no traits" do
      let(:factory) { find_factory(:manager) }

      specify do
        expect(structure).to eq(FactoryTrace::Structures::Factory.new(["manager"], [], parent_name: "admin", declaration_names: ["with_phone"]))
      end
    end

    context "when has traits" do
      let(:factory) { find_factory(:user) }

      specify do
        expect(structure).to eq(FactoryTrace::Structures::Factory.new(["user"], [FactoryTrace::Structures::Trait.new("with_phone")]))
      end
    end

    context "when has aliases" do
      let(:factory) { find_factory("article") }

      specify do
        expect(structure).to eq(FactoryTrace::Structures::Factory.new(["article", "post"], []))
      end
    end
  end
end
