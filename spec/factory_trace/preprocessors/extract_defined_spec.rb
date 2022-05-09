# frozen_string_literal: true

RSpec.describe FactoryTrace::Preprocessors::ExtractDefined do
  describe ".call" do
    subject(:structure) { described_class.call }

    specify do
      collection = FactoryTrace::Structures::Collection.new(
        [
          FactoryTrace::Structures::Factory.new(
            ["user"],
            [
              FactoryTrace::Structures::Trait.new("with_phone")
            ]
          ),
          FactoryTrace::Structures::Factory.new(
            ["user_with_defaults"],
            [],
            declaration_names: ["with_address", "with_phone"],
            parent_name: "user"
          ),
          FactoryTrace::Structures::Factory.new(
            ["admin"],
            [
              FactoryTrace::Structures::Trait.new("with_email"),
              FactoryTrace::Structures::Trait.new("combination", declaration_names: ["with_email", "with_phone"])
            ],
            parent_name: "user"
          ),
          FactoryTrace::Structures::Factory.new(["manager"], [], parent_name: "admin", declaration_names: ["with_phone"]),
          FactoryTrace::Structures::Factory.new(
            ["company"],
            [
              FactoryTrace::Structures::Trait.new("with_manager", declaration_names: ["manager"])
            ]
          ),
          FactoryTrace::Structures::Factory.new(["article", "post"], []),
          FactoryTrace::Structures::Factory.new(["comment"], [], declaration_names: ["post"]),
          FactoryTrace::Structures::Factory.new(
            ["task"],
            []
          )
        ],
        [
          FactoryTrace::Structures::Trait.new("with_address")
        ]
      )

      expect(structure).to eq(collection)
    end
  end
end
