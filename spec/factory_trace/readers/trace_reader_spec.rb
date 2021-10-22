RSpec.describe FactoryTrace::Readers::TraceReader do
  subject(:reader) { described_class.new(input) }

  describe '.read_from_files' do
    let(:input1) do
      <<~TEXT
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
                    "declaration_names": []
                  }
                ],
                "parent_name": null,
                "declaration_names": []
              },
              {
                "names": [
                  "admin"
                ],
                "traits": [
                  {
                    "name": "with_email",
                    "declaration_names": []
                  },
                  {
                    "name": "combination",
                    "declaration_names": [
                      "with_email",
                      "with_phone"
                    ]
                  }
                ],
                "parent_name": "user",
                "declaration_names": []
              }
            ],
            "traits": [
              {
                "name": "with_address",
                "declaration_names": []
              }
            ]
          },
          "used": {
            "factories": [
              {
                "names": [
                  "user"
                ],
                "traits": [
                  {
                    "name": "with_phone",
                    "declaration_names": []
                  }
                ],
                "parent_name": null,
                "declaration_names": []
              },
              {
                "names": [
                  "admin"
                ],
                "traits": [
                  {
                    "name": "with_email",
                    "declaration_names": []
                  }
                ],
                "parent_name": null,
                "declaration_names": []
              }
            ],
            "traits": []
          }
        }
      TEXT
    end

    let(:input2) do
      <<~TEXT
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
                    "declaration_names": []
                  }
                ],
                "parent_name": null,
                "declaration_names": []
              },
              {
                "names": [
                  "admin"
                ],
                "traits": [
                  {
                    "name": "with_email",
                    "declaration_names": []
                  },
                  {
                    "name": "combination",
                    "declaration_names": [
                      "with_email",
                      "with_phone"
                    ]
                  }
                ],
                "parent_name": "user",
                "declaration_names": []
              }
            ],
            "traits": [
              {
                "name": "with_address",
                "declaration_names": []
              }
            ]
          },
          "used": {
            "factories": [
              {
                "names": [
                  "user"
                ],
                "traits": [
                  {
                    "name": "with_address",
                    "declaration_names": []
                  }
                ],
                "parent_name": null,
                "declaration_names": []
              },
              {
                "names": ["admin"],
                "traits": [],
                "parent_name": null,
                "declaration_names": []
              }
            ],
            "traits": []
          }
        }
      TEXT
    end

    let(:file1) { Tempfile.new('file1.txt') }
    let(:file2) { Tempfile.new('file2.txt') }

    before do
      file1.write(input1)
      file2.write(input2)
      file1.rewind
      file2.rewind
    end

    it 'reads' do
      result = {
        defined: FactoryTrace::Structures::Collection.new(
          [
            FactoryTrace::Structures::Factory.new(
              ['user'],
              [FactoryTrace::Structures::Trait.new('with_phone')]
            ),
            FactoryTrace::Structures::Factory.new(
              ['admin'],
              [
                FactoryTrace::Structures::Trait.new('with_email'),
                FactoryTrace::Structures::Trait.new('combination', declaration_names: ['with_email', 'with_phone'])
              ],
              parent_name: 'user'
            ),
          ],
          [
            FactoryTrace::Structures::Trait.new('with_address')
          ]
        ),
        used: FactoryTrace::Structures::Collection.new(
          [
            FactoryTrace::Structures::Factory.new(
              ['user'],
              [
                FactoryTrace::Structures::Trait.new('with_phone'),
                FactoryTrace::Structures::Trait.new('with_address')
              ]
            ),
            FactoryTrace::Structures::Factory.new(
              ['admin'],
              [FactoryTrace::Structures::Trait.new('with_email')]
            )
          ]
        )
      }

      expect(described_class.read_from_files(file1, file2)).to eq(result)
    end
  end

  describe '#read' do
    let(:input) do
      StringIO.new <<~TEXT
        {
          "defined": {
            "factories": [
              {
                "names": ["user"],
                "traits": [
                  {
                    "name": "with_phone",
                    "declaration_names": []
                  },
                  {
                    "name": "combination",
                    "declaration_names": [
                      "with_email",
                      "with_phone"
                    ]
                  }
                ],
                "parent_name": null,
                "declaration_names": []
              }
            ],
            "traits": [
              {
                "name": "with_address",
                "declaration_names": []
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

    it 'reads' do
      result = {
        defined: FactoryTrace::Structures::Collection.new(
          [
            FactoryTrace::Structures::Factory.new(
              ['user'],
              [
                FactoryTrace::Structures::Trait.new('with_phone'),
                FactoryTrace::Structures::Trait.new('combination', declaration_names: ['with_email', 'with_phone'])
              ]
            )
          ],
          [
            FactoryTrace::Structures::Trait.new('with_address')
          ]
        ),
        used: FactoryTrace::Structures::Collection.new
      }

      expect(reader.read).to eq(result)
    end
  end
end
