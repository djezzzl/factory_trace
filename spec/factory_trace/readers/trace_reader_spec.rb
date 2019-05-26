require 'tempfile'

RSpec.describe FactoryTrace::Readers::TraceReader do
  subject(:reader) { described_class.new(input) }

  describe '.read_from_files' do
    let(:input1) do
      <<~TEXT
      {
        "defined": {
          "factories": [
            {
              "name": "user",
              "parent_name": null,
              "trait_names": [
                "with_phone"
              ]
            },
            {
              "name": "admin",
              "parent_name": "user",
              "trait_names": [
                "with_email"
              ]
            }
          ],
          "traits": [
            {
              "name": "with_address",
              "owner_name": null
            }
          ]
        },
        "used": {
          "factories": [
            {
              "name": "user",
              "parent_name": null,
              "trait_names": [
                "with_address"
              ]
            }
          ],
          "traits": [

          ]
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
              "name": "user",
              "parent_name": null,
              "trait_names": [
                "with_phone"
              ]
            },
            {
              "name": "admin",
              "parent_name": "user",
              "trait_names": [
                "with_email"
              ]
            }
          ],
          "traits": [
            {
              "name": "with_address",
              "owner_name": null
            }
          ]
        },
        "used": {
          "factories": [
            {
              "name": "admin",
              "parent_name": null,
              "trait_names": [
                "with_phone"
              ]
            }
          ],
          "traits": [

          ]
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
          {
            'user' => FactoryTrace::Structures::Factory.new('user', nil, ['with_phone']),
            'admin' => FactoryTrace::Structures::Factory.new('admin', 'user', ['with_email']),
          },
          {
            'with_address' => FactoryTrace::Structures::Trait.new('with_address', nil)
          }
        ),
        used: FactoryTrace::Structures::Collection.new(
          {
            'user' => FactoryTrace::Structures::Factory.new('user', nil, ['with_address']),
            'admin' => FactoryTrace::Structures::Factory.new('admin', nil, ['with_phone'])
          }
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
              "name": "user",
              "parent_name": null,
              "trait_names": [
                "with_phone"
              ]
            }
          ],
          "traits": [
            {
              "name": "with_address",
              "owner_name": null
            }
          ]
        },
        "used": {
          "factories": [

          ],
          "traits": [

          ]
        }
      }
      TEXT
    end

    it 'reads' do
      result = {
        defined: FactoryTrace::Structures::Collection.new(
          {
            'user' => FactoryTrace::Structures::Factory.new('user', nil, ['with_phone'])
          },
          {
            'with_address' => FactoryTrace::Structures::Trait.new('with_address', nil)
          }
        ),
        used: FactoryTrace::Structures::Collection.new
      }

      expect(reader.read).to eq(result)
    end
  end
end
