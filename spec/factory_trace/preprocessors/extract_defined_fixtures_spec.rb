# frozen_string_literal: true

RSpec.describe FactoryTrace::Preprocessors::ExtractDefinedFixtures do
  describe ".call" do
    subject(:collection) { described_class.call(fixture_path) }

    let(:fixture_path) { File.join(File.dirname(__FILE__), "../../fixtures") }

    context "when fixture files exist" do
      it "extracts fixture sets and entries from all YAML files" do
        expect(collection.factories.map { |f| f.names.first }.sort).to eq(["companies", "users"])
      end

      it "extracts fixture entries as traits" do
        users_factory = collection.factories.find { |f| f.names.first == "users" }
        expect(users_factory.traits.map(&:name).sort).to eq(["one", "two"])
      end

      it "includes definition paths for fixture entries" do
        users_factory = collection.factories.find { |f| f.names.first == "users" }
        one_entry = users_factory.traits.find { |t| t.name == "one" }
        expect(one_entry.definition_path).to match(/users\.yml:\d+/)
      end

      it "includes definition paths for fixture sets" do
        users_factory = collection.factories.find { |f| f.names.first == "users" }
        expect(users_factory.definition_path).to match(/users\.yml:1/)
      end
    end

    context "when the fixture path does not exist" do
      let(:fixture_path) { "/nonexistent/path" }

      it "returns an empty collection" do # rubocop:disable RSpec/MultipleExpectations
        expect(collection.factories).to eq([])
        expect(collection.traits).to eq([])
      end
    end

    context "when given nil as fixture path" do
      let(:fixture_path) { nil }

      it "returns an empty collection" do # rubocop:disable RSpec/MultipleExpectations
        expect(collection.factories).to eq([])
        expect(collection.traits).to eq([])
      end
    end
  end
end
