RSpec.describe FactoryTrace::Processors::FindUnused do
  subject(:checker) { described_class.call(FactoryTrace::Preprocessors::ExtractDefined.call, FactoryTrace::Preprocessors::ExtractUsed.call(data)) }

  describe 'check!' do
    context 'when all factories are not used' do
      let(:data) { {} }

      specify do
        expect(checker).to eq([
          {code: :used, value: 0},
          {code: :used_indirectly, value: 0},
          {code: :unused, value: 8},
          {code: :unused, factory_name: 'user'},
          {code: :unused, factory_name: 'user', trait_name: 'with_phone'},
          {code: :unused, factory_name: 'admin'},
          {code: :unused, factory_name: 'admin', trait_name: 'with_email'},
          {code: :unused, factory_name: 'company'},
          {code: :unused, factory_name: 'article'},
          {code: :unused, factory_name: 'comment'},
          {code: :unused, trait_name: 'with_address'},
        ])
      end
    end

    context 'when a factory used through alias' do
      let(:data) { {'post' => Set.new} }

      specify do
        expect(checker).to eq([
          {code: :used, value: 1},
          {code: :used_indirectly, value: 0},
          {code: :unused, value: 7},
          {code: :unused, factory_name: 'user'},
          {code: :unused, factory_name: 'user', trait_name: 'with_phone'},
          {code: :unused, factory_name: 'admin'},
          {code: :unused, factory_name: 'admin', trait_name: 'with_email'},
          {code: :unused, factory_name: 'company'},
          {code: :unused, factory_name: 'comment'},
          {code: :unused, trait_name: 'with_address'}
        ])
      end
    end

    context 'when a factory was used without its traits' do
      let(:data) { {'user' => Set.new} }

      specify do
        expect(checker).to eq([
          {code: :used, value: 1},
          {code: :used_indirectly, value: 0},
          {code: :unused, value: 7},
          {code: :unused, factory_name: 'user', trait_name: 'with_phone'},
          {code: :unused, factory_name: 'admin'},
          {code: :unused, factory_name: 'admin', trait_name: 'with_email'},
          {code: :unused, factory_name: 'company'},
          {code: :unused, factory_name: 'article'},
          {code: :unused, factory_name: 'comment'},
          {code: :unused, trait_name: 'with_address'}
        ])
      end
    end

    context 'when a factory was used with its traits' do
      let(:data) { {'user' => Set.new(['with_phone'])} }

      specify do
        expect(checker).to eq([
          {code: :used, value: 2},
          {code: :used_indirectly, value: 0},
          {code: :unused, value: 6},
          {code: :unused, factory_name: 'admin'},
          {code: :unused, factory_name: 'admin', trait_name: 'with_email'},
          {code: :unused, factory_name: 'company'},
          {code: :unused, factory_name: 'article'},
          {code: :unused, factory_name: 'comment'},
          {code: :unused, trait_name: 'with_address'}
        ])
      end
    end

    context 'when a child factory was used' do
      let(:data) { {'admin' => []} }

      specify do
        expect(checker).to eq([
          {code: :used, value: 1},
          {code: :used_indirectly, value: 1},
          {code: :unused, value: 6},
          {code: :used_indirectly, factory_name: 'user', child_factories_names: ['admin']},
          {code: :unused, factory_name: 'user', trait_name: 'with_phone'},
          {code: :unused, factory_name: 'admin', trait_name: 'with_email'},
          {code: :unused, factory_name: 'company'},
          {code: :unused, factory_name: 'article'},
          {code: :unused, factory_name: 'comment'},
          {code: :unused, trait_name: 'with_address'}
        ])
      end
    end

    context 'when a global trait was used' do
      let(:data) { {'user' => Set.new(['with_address'])} }

      specify do
        expect(checker).to eq([
          {code: :used, value: 2},
          {code: :used_indirectly, value: 0},
          {code: :unused, value: 6},
          {code: :unused, factory_name: 'user', trait_name: 'with_phone'},
          {code: :unused, factory_name: 'admin'},
          {code: :unused, factory_name: 'admin', trait_name: 'with_email'},
          {code: :unused, factory_name: 'company'},
          {code: :unused, factory_name: 'article'},
          {code: :unused, factory_name: 'comment'}
        ])
      end
    end

    context 'when a parent trait was used' do
      let(:data) { {'admin' => Set.new(['with_phone'])} }

      specify do
        expect(checker).to eq([
          {code: :used, value: 2},
          {code: :used_indirectly, value: 1},
          {code: :unused, value: 5},
          {code: :used_indirectly, factory_name: 'user', child_factories_names: ['admin']},
          {code: :unused, factory_name: 'admin', trait_name: 'with_email'},
          {code: :unused, factory_name: 'company'},
          {code: :unused, factory_name: 'article'},
          {code: :unused, factory_name: 'comment'},
          {code: :unused, trait_name: 'with_address'}
        ])
      end
    end

    context 'when everything were used' do
      let(:data) { {'admin' => Set.new(['with_phone', 'with_email']), 'company' => Set.new(['with_address']), 'article' => Set.new, 'comment' => Set.new()} }

      specify do
        expect(checker).to eq([
          {code: :used, value: 7},
          {code: :used_indirectly, value: 1},
          {code: :unused, value: 0},
          {code: :used_indirectly, factory_name: 'user', child_factories_names: ['admin']}
        ])
      end
    end
  end
end
