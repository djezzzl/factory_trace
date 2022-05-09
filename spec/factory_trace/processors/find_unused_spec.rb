# frozen_string_literal: true

RSpec.describe FactoryTrace::Processors::FindUnused do
  subject(:checker) { described_class.call(FactoryTrace::Preprocessors::ExtractDefined.call, FactoryTrace::Preprocessors::ExtractUsed.call(data)) }

  describe "check!" do
    context "when all factories are not used" do
      let(:data) { {} }

      specify do
        expect(checker).to eq([
          {code: :used, value: 0},
          {code: :unused, value: 13},
          {code: :unused, factory_names: ["user"]},
          {code: :unused, factory_names: ["user"], trait_name: "with_phone"},
          {code: :unused, factory_names: ["user_with_defaults"]},
          {code: :unused, factory_names: ["admin"]},
          {code: :unused, factory_names: ["admin"], trait_name: "with_email"},
          {code: :unused, factory_names: ["admin"], trait_name: "combination"},
          {code: :unused, factory_names: ["manager"]},
          {code: :unused, factory_names: ["company"]},
          {code: :unused, factory_names: ["company"], trait_name: "with_manager"},
          {code: :unused, factory_names: ["article", "post"]},
          {code: :unused, factory_names: ["comment"]},
          {code: :unused, factory_names: ["task"]},
          {code: :unused, trait_name: "with_address"}
        ])
      end
    end

    context "when a factory used through alias" do
      let(:data) { {"post" => Set.new} }

      specify do
        expect(checker).to eq([
          {code: :used, value: 1},
          {code: :unused, value: 12},
          {code: :unused, factory_names: ["user"]},
          {code: :unused, factory_names: ["user"], trait_name: "with_phone"},
          {code: :unused, factory_names: ["user_with_defaults"]},
          {code: :unused, factory_names: ["admin"]},
          {code: :unused, factory_names: ["admin"], trait_name: "with_email"},
          {code: :unused, factory_names: ["admin"], trait_name: "combination"},
          {code: :unused, factory_names: ["manager"]},
          {code: :unused, factory_names: ["company"]},
          {code: :unused, factory_names: ["company"], trait_name: "with_manager"},
          {code: :unused, factory_names: ["comment"]},
          {code: :unused, factory_names: ["task"]},
          {code: :unused, trait_name: "with_address"}
        ])
      end
    end

    context "when a factory was used without its traits" do
      let(:data) { {"user" => Set.new} }

      specify do
        expect(checker).to eq([
          {code: :used, value: 1},
          {code: :unused, value: 12},
          {code: :unused, factory_names: ["user"], trait_name: "with_phone"},
          {code: :unused, factory_names: ["user_with_defaults"]},
          {code: :unused, factory_names: ["admin"]},
          {code: :unused, factory_names: ["admin"], trait_name: "with_email"},
          {code: :unused, factory_names: ["admin"], trait_name: "combination"},
          {code: :unused, factory_names: ["manager"]},
          {code: :unused, factory_names: ["company"]},
          {code: :unused, factory_names: ["company"], trait_name: "with_manager"},
          {code: :unused, factory_names: ["article", "post"]},
          {code: :unused, factory_names: ["comment"]},
          {code: :unused, factory_names: ["task"]},
          {code: :unused, trait_name: "with_address"}
        ])
      end
    end

    context "when a factory was used with its traits" do
      let(:data) { {"user" => Set.new(["with_phone"])} }

      specify do
        expect(checker).to eq([
          {code: :used, value: 2},
          {code: :unused, value: 11},
          {code: :unused, factory_names: ["user_with_defaults"]},
          {code: :unused, factory_names: ["admin"]},
          {code: :unused, factory_names: ["admin"], trait_name: "with_email"},
          {code: :unused, factory_names: ["admin"], trait_name: "combination"},
          {code: :unused, factory_names: ["manager"]},
          {code: :unused, factory_names: ["company"]},
          {code: :unused, factory_names: ["company"], trait_name: "with_manager"},
          {code: :unused, factory_names: ["article", "post"]},
          {code: :unused, factory_names: ["comment"]},
          {code: :unused, factory_names: ["task"]},
          {code: :unused, trait_name: "with_address"}
        ])
      end
    end

    context "when a child factory was used" do
      let(:data) { {"admin" => []} }

      specify do
        expect(checker).to eq([
          {code: :used, value: 2},
          {code: :unused, value: 11},
          {code: :unused, factory_names: ["user"], trait_name: "with_phone"},
          {code: :unused, factory_names: ["user_with_defaults"]},
          {code: :unused, factory_names: ["admin"], trait_name: "with_email"},
          {code: :unused, factory_names: ["admin"], trait_name: "combination"},
          {code: :unused, factory_names: ["manager"]},
          {code: :unused, factory_names: ["company"]},
          {code: :unused, factory_names: ["company"], trait_name: "with_manager"},
          {code: :unused, factory_names: ["article", "post"]},
          {code: :unused, factory_names: ["comment"]},
          {code: :unused, factory_names: ["task"]},
          {code: :unused, trait_name: "with_address"}
        ])
      end
    end

    context "when a global trait was used" do
      let(:data) { {"user" => Set.new(["with_address"])} }

      specify do
        expect(checker).to eq([
          {code: :used, value: 2},
          {code: :unused, value: 11},
          {code: :unused, factory_names: ["user"], trait_name: "with_phone"},
          {code: :unused, factory_names: ["user_with_defaults"]},
          {code: :unused, factory_names: ["admin"]},
          {code: :unused, factory_names: ["admin"], trait_name: "with_email"},
          {code: :unused, factory_names: ["admin"], trait_name: "combination"},
          {code: :unused, factory_names: ["manager"]},
          {code: :unused, factory_names: ["company"]},
          {code: :unused, factory_names: ["company"], trait_name: "with_manager"},
          {code: :unused, factory_names: ["article", "post"]},
          {code: :unused, factory_names: ["comment"]},
          {code: :unused, factory_names: ["task"]}
        ])
      end
    end

    context "when a parent trait was used" do
      let(:data) { {"admin" => Set.new(["with_phone"])} }

      specify do
        expect(checker).to eq([
          {code: :used, value: 3},
          {code: :unused, value: 10},
          {code: :unused, factory_names: ["user_with_defaults"]},
          {code: :unused, factory_names: ["admin"], trait_name: "with_email"},
          {code: :unused, factory_names: ["admin"], trait_name: "combination"},
          {code: :unused, factory_names: ["manager"]},
          {code: :unused, factory_names: ["company"]},
          {code: :unused, factory_names: ["company"], trait_name: "with_manager"},
          {code: :unused, factory_names: ["article", "post"]},
          {code: :unused, factory_names: ["comment"]},
          {code: :unused, factory_names: ["task"]},
          {code: :unused, trait_name: "with_address"}
        ])
      end
    end

    context "when everything were used" do
      let(:data) do
        {
          "admin" => Set.new(["with_phone", "with_email", "combination"]),
          "company" => Set.new(["with_address", "with_manager"]),
          "article" => Set.new,
          "comment" => Set.new,
          "manager" => Set.new,
          "user_with_defaults" => Set.new,
          "task" => Set.new
        }
      end

      specify do
        expect(checker).to eq([
          {code: :used, value: 13},
          {code: :unused, value: 0}
        ])
      end
    end

    context "when trait is used indirectly through another trait" do
      let(:data) { {"admin" => Set.new(["combination"])} }

      specify do
        expect(checker).to eq([
          {code: :used, value: 5},
          {code: :unused, value: 8},
          {code: :unused, factory_names: ["user_with_defaults"]},
          {code: :unused, factory_names: ["manager"]},
          {code: :unused, factory_names: ["company"]},
          {code: :unused, factory_names: ["company"], trait_name: "with_manager"},
          {code: :unused, factory_names: ["article", "post"]},
          {code: :unused, factory_names: ["comment"]},
          {code: :unused, factory_names: ["task"]},
          {code: :unused, trait_name: "with_address"}
        ])
      end
    end

    context "when trait is used indirectly through factory" do
      let(:data) { {"manager" => Set.new} }

      specify do
        expect(checker).to eq([
          {code: :used, value: 4},
          {code: :unused, value: 9},
          {code: :unused, factory_names: ["user_with_defaults"]},
          {code: :unused, factory_names: ["admin"], trait_name: "with_email"},
          {code: :unused, factory_names: ["admin"], trait_name: "combination"},
          {code: :unused, factory_names: ["company"]},
          {code: :unused, factory_names: ["company"], trait_name: "with_manager"},
          {code: :unused, factory_names: ["article", "post"]},
          {code: :unused, factory_names: ["comment"]},
          {code: :unused, factory_names: ["task"]},
          {code: :unused, trait_name: "with_address"}
        ])
      end
    end

    context "when factory is used indirectly through factory" do
      let(:data) { {"comment" => Set.new} }

      specify do
        expect(checker).to eq([
          {code: :used, value: 2},
          {code: :unused, value: 11},
          {code: :unused, factory_names: ["user"]},
          {code: :unused, factory_names: ["user"], trait_name: "with_phone"},
          {code: :unused, factory_names: ["user_with_defaults"]},
          {code: :unused, factory_names: ["admin"]},
          {code: :unused, factory_names: ["admin"], trait_name: "with_email"},
          {code: :unused, factory_names: ["admin"], trait_name: "combination"},
          {code: :unused, factory_names: ["manager"]},
          {code: :unused, factory_names: ["company"]},
          {code: :unused, factory_names: ["company"], trait_name: "with_manager"},
          {code: :unused, factory_names: ["task"]},
          {code: :unused, trait_name: "with_address"}
        ])
      end
    end

    context "when factory is used indirectly through trait" do
      let(:data) { {"company" => Set.new(["with_manager"])} }

      specify do
        expect(checker).to eq([
          {code: :used, value: 6},
          {code: :unused, value: 7},
          {code: :unused, factory_names: ["user_with_defaults"]},
          {code: :unused, factory_names: ["admin"], trait_name: "with_email"},
          {code: :unused, factory_names: ["admin"], trait_name: "combination"},
          {code: :unused, factory_names: ["article", "post"]},
          {code: :unused, factory_names: ["comment"]},
          {code: :unused, factory_names: ["task"]},
          {code: :unused, trait_name: "with_address"}
        ])
      end
    end

    context "when factory with default traits was used" do
      let(:data) { {"user_with_defaults" => Set.new} }

      specify do
        expect(checker).to eq([
          {code: :used, value: 4},
          {code: :unused, value: 9},
          {code: :unused, factory_names: ["admin"]},
          {code: :unused, factory_names: ["admin"], trait_name: "with_email"},
          {code: :unused, factory_names: ["admin"], trait_name: "combination"},
          {code: :unused, factory_names: ["manager"]},
          {code: :unused, factory_names: ["company"]},
          {code: :unused, factory_names: ["company"], trait_name: "with_manager"},
          {code: :unused, factory_names: ["article", "post"]},
          {code: :unused, factory_names: ["comment"]},
          {code: :unused, factory_names: ["task"]}
        ])
      end
    end
  end
end
