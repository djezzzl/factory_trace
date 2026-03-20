# frozen_string_literal: true

RSpec.describe FactoryTrace::Writers::TraceWriter do
  subject(:printer) { described_class.new(output) }

  describe "#print" do
    let(:output) { StringIO.new }
    let(:defined) do
      FactoryTrace::Structures::Collection.new(
        [
          FactoryTrace::Structures::Factory.new(
            ["user"],
            [
              FactoryTrace::Structures::Trait.new("with_phone")
            ]
          ),
          FactoryTrace::Structures::Factory.new(
            ["admin"],
            [
              FactoryTrace::Structures::Trait.new("with_email"),
              FactoryTrace::Structures::Trait.new("combination", declaration_names: ["with_email", "with_phone"])
            ],
            parent_name: "user",
            definition_path: "path/to/file:10"
          )
        ],
        [
          FactoryTrace::Structures::Trait.new("with_address")
        ]
      )
    end

    let(:used) do
      FactoryTrace::Structures::Collection.new({}, {})
    end

    it "prints the result" do
      printer.write(defined, used)

      expect(output.string).to eq(<<~TEXT)
        {
          "defined": {
            "factories": [
              {
                "names": [
                  "user"
                ],
                "traits": [
                  {
                    "name": "with_phone",
                    "declaration_names": [],
                    "definition_path": null
                  }
                ],
                "parent_name": null,
                "declaration_names": [],
                "definition_path": null
              },
              {
                "names": [
                  "admin"
                ],
                "traits": [
                  {
                    "name": "with_email",
                    "declaration_names": [],
                    "definition_path": null
                  },
                  {
                    "name": "combination",
                    "declaration_names": [
                      "with_email",
                      "with_phone"
                    ],
                    "definition_path": null
                  }
                ],
                "parent_name": "user",
                "declaration_names": [],
                "definition_path": "path/to/file:10"
              }
            ],
            "traits": [
              {
                "name": "with_address",
                "declaration_names": [],
                "definition_path": null
              }
            ]
          },
          "used": {
            "factories": [],
            "traits": []
          }
        }
      TEXT
    end
  end
end
