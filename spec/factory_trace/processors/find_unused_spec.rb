RSpec.describe FactoryTrace::Processors::FindUnused do
  subject(:checker) { described_class.call(FactoryTrace::Preprocessors::ExtractDefined.call, FactoryTrace::Preprocessors::ExtractUsed.call(data)) }

  describe 'check!' do
    context 'when all factories are not used' do
      let(:data) { {} }

      it 'returns everything' do
        expect(checker).to eq([
          {code: :used, value: 0},
          {code: :used_indirectly, value: 0},
          {code: :unused, value: 8},
          {code: :unused, factory_name: 'user'},
          {code: :unused, factory_name: 'user', trait_name: 'with_phone'},
          {code: :unused, factory_name: 'admin'},
          {code: :unused, factory_name: 'admin', trait_name: 'with_email'},
          {code: :unused, factory_name: 'article'},
          {code: :unused, factory_name: 'comment'},
          {code: :unused, factory_name: 'company'},
          {code: :unused, trait_name: 'with_address'},
        ])
      end
    end

    context 'when a factory was used' do
      let(:data) do
        {
          'user' => { traits: Set.new, alias_names: Set.new }
        }
      end

      it 'returns except used and for used returns all traits' do
        expect(checker).to eq([
          {code: :used, value: 1},
          {code: :used_indirectly, value: 0},
          {code: :unused, value: 7},
          {code: :unused, factory_name: 'user', trait_name: 'with_phone'},
          {code: :unused, factory_name: 'admin'},
          {code: :unused, factory_name: 'admin', trait_name: 'with_email'},
          {code: :unused, factory_name: 'article'},
          {code: :unused, factory_name: 'comment'},
          {code: :unused, factory_name: 'company'},
          {code: :unused, trait_name: 'with_address'}
        ])
      end
    end

    context 'when a factory was used with its trait' do
      let(:data) do
        {
          'user' => { traits: Set.new(['with_phone']), alias_names: Set.new }
        }
      end

      it 'returns except used and for used returns all traits' do
        expect(checker).to eq([
          {code: :used, value: 2},
          {code: :used_indirectly, value: 0},
          {code: :unused, value: 6},
          {code: :unused, factory_name: 'admin'},
          {code: :unused, factory_name: 'admin', trait_name: 'with_email'},
          {code: :unused, factory_name: 'article'},
          {code: :unused, factory_name: 'comment'},
          {code: :unused, factory_name: 'company'},
          {code: :unused, trait_name: 'with_address'}
        ])
      end
    end

    context 'when a global trait was used' do
      let(:data) do
        {
          'user' => { traits: Set.new(['with_address']), alias_names: Set.new }
        }
      end

      it 'returns except used and global trait' do
        expect(checker).to eq([
          {code: :used, value: 2},
          {code: :used_indirectly, value: 0},
          {code: :unused, value: 6},
          {code: :unused, factory_name: 'user', trait_name: 'with_phone'},
          {code: :unused, factory_name: 'admin'},
          {code: :unused, factory_name: 'admin', trait_name: 'with_email'},
          {code: :unused, factory_name: 'article'},
          {code: :unused, factory_name: 'comment'},
          {code: :unused, factory_name: 'company'}
        ])
      end
    end

    context 'when a parent trait was used' do
      let(:data) do
        {
          'admin' => { traits: Set.new(['with_phone']), alias_names: Set.new }
        }
      end

      it 'returns except that factory and parent trait' do
        expect(checker).to eq([
          {code: :used, value: 2},
          {code: :used_indirectly, value: 1},
          {code: :unused, value: 5},
          {code: :used_indirectly, factory_name: 'user', child_factories_names: ['admin']},
          {code: :unused, factory_name: 'admin', trait_name: 'with_email'},
          {code: :unused, factory_name: 'article'},
          {code: :unused, factory_name: 'comment'},
          {code: :unused, factory_name: 'company'},
          {code: :unused, trait_name: 'with_address'}
        ])
      end
    end

    context 'when almost everything were used' do
      let(:data) do
        {
          'admin' => { traits: Set.new(['with_phone', 'with_email']), alias_names: Set.new },
          'company' => { traits: Set.new(['with_address']), alias_names: Set.new }
        }
      end

      it 'returns except parent factory' do
        expect(checker).to eq([
          {code: :used, value: 5},
          {code: :used_indirectly, value: 1},
          {code: :unused, value: 2},
          {code: :used_indirectly, factory_name: 'user', child_factories_names: ['admin']},
          {code: :unused, factory_name: 'article'},
          {code: :unused, factory_name: 'comment'}
        ])
      end
    end
  end
end
