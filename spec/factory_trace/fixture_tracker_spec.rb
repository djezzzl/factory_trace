# frozen_string_literal: true

RSpec.describe FactoryTrace::FixtureTracker do
  subject(:tracker) { described_class.new }

  describe "#track!" do
    context "when ActiveRecord::FixtureSet is not defined" do
      before do
        hide_const("ActiveRecord::FixtureSet") if defined?(ActiveRecord::FixtureSet)
        tracker.track!
      end

      it "does not raise an error" do
        expect(tracker.storage).to eq({})
      end
    end

    context "when ActiveRecord::FixtureSet is defined" do
      let(:fixture_set_class) do
        Class.new do
          attr_reader :name

          def initialize(name, fixtures)
            @name = name
            @fixtures = fixtures
          end

          def [](fixture_name)
            @fixtures[fixture_name]
          end
        end
      end

      before do
        stub_const("ActiveRecord::FixtureSet", fixture_set_class)
        tracker.track!
      end

      it "records fixture set and entry access" do
        fixture_set = ActiveRecord::FixtureSet.new("users", {"one" => "record_one", "two" => "record_two"})
        fixture_set["one"]

        expect(tracker.storage).to eq("users" => Set.new(["one"]))
      end

      it "records multiple entries from the same fixture set" do
        fixture_set = ActiveRecord::FixtureSet.new("users", {"one" => "record_one", "two" => "record_two"})
        fixture_set["one"]
        fixture_set["two"]

        expect(tracker.storage).to eq("users" => Set.new(["one", "two"]))
      end

      it "records entries from multiple fixture sets" do
        users = ActiveRecord::FixtureSet.new("users", {"one" => "user_one"})
        companies = ActiveRecord::FixtureSet.new("companies", {"acme" => "acme_corp"})

        users["one"]
        companies["acme"]

        expect(tracker.storage).to eq(
          "users" => Set.new(["one"]),
          "companies" => Set.new(["acme"])
        )
      end

      it "does not record nil fixture names" do
        fixture_set = ActiveRecord::FixtureSet.new("users", {})
        fixture_set[nil]

        expect(tracker.storage).to eq({})
      end

      it "still returns the fixture value from the underlying method" do
        fixture_set = ActiveRecord::FixtureSet.new("users", {"one" => "record_one"})

        expect(fixture_set["one"]).to eq("record_one")
      end
    end
  end
end
