RSpec.describe FactoryTrace::Processors::FindUnused do
  subject(:checker) { described_class.call(FactoryTrace::Preprocessors::ExtractDefined.call, FactoryTrace::Preprocessors::ExtractUsed.call(data)) }

  describe 'check!' do
    context 'when all factories are not used' do
      let(:data) { {} }

      it 'returns everything' do
        expect(checker).to eq([
          {code: :used, value: 0},
          {code: :unused, value: 4},
          {code: :unused, trait_name: 'with_address'},
          {code: :unused, factory_name: 'user'},
          {code: :unused, factory_name: 'admin'},
          {code: :unused, factory_name: 'company'}
        ])
      end
    end

    context 'when a factory was used' do
      let(:data) { {'user' => Set.new} }

      it 'returns except used and for used returns all traits' do
        expect(checker).to eq([
          {code: :used, value: 1},
          {code: :unused, value: 4},
          {code: :unused, trait_name: 'with_address'},
          {code: :unused, factory_name: 'user', trait_name: 'with_phone'},
          {code: :unused, factory_name: 'admin'},
          {code: :unused, factory_name: 'company'}
        ])
      end
    end

    context 'when a factory was used with its trait' do
      let(:data) { {'user' => Set.new([:with_phone])} }

      it 'returns except used and for used returns all traits' do
        expect(checker).to eq([
          {code: :used, value: 2},
          {code: :unused, value: 3},
          {code: :unused, trait_name: 'with_address'},
          {code: :unused, factory_name: 'admin'},
          {code: :unused, factory_name: 'company'}
        ])
      end
    end

    context 'when a child trait was used with parent' do
      let(:data) { {'user' => [], 'admin' => []} }

      it 'returns except used and returns parents trait only with parent factory' do
        expect(checker).to eq([
          {code: :used, value: 2},
          {code: :unused, value: 4},
          {code: :unused, trait_name: 'with_address'},
          {code: :unused, factory_name: 'user', trait_name: 'with_phone'},
          {code: :unused, factory_name: 'admin', trait_name: 'with_email'},
          {code: :unused, factory_name: 'company'}
        ])
      end
    end

    context 'when a global trait was used' do
      let(:data) { {'user' => Set.new(['with_address'])} }

      it 'returns except used and global trait' do
        expect(checker).to eq([
          {code: :used, value: 2},
          {code: :unused, value: 3},
          {code: :unused, factory_name: 'user', trait_name: 'with_phone'},
          {code: :unused, factory_name: 'admin'},
          {code: :unused, factory_name: 'company'}
        ])
      end
    end

    context 'when a parent trait was used' do
      let(:data) { {'admin' => Set.new(['with_phone'])} }

      it 'returns except that factory and parent trait' do
        expect(checker).to eq([
          {code: :used, value: 3},
          {code: :unused, value: 3},
          {code: :unused, trait_name: 'with_address'},
          {code: :unused, factory_name: 'admin', trait_name: 'with_email'},
          {code: :unused, factory_name: 'company'}
        ])
      end
    end

    context 'when everything were used' do
      let(:data) { {'admin' => Set.new(['with_phone', 'with_email']), 'company' => Set.new(['with_address'])} }

      it 'returns nothing' do
        expect(checker).to eq([
          {code: :used, value: 6},
          {code: :unused, value: 0},
        ])
      end
    end

    # context 'when a child factory was used without parent' do
    #   let(:data) { {'admin' => Set.new} }
    #
    #   it 'returns parent as used indirectly' do
    #     expect(checker).to eq([
    #       {code: :used, value: 1},
    #       {code: :unused, value: 4},
    #       {code: :indirectly, factory_name: 'user'},
    #       {code: :unused, trait_name: 'with_address'},
    #       {code: :unused, factory_name: 'admin', trait_name: 'with_email'},
    #       {code: :unused, factory_name: 'company'}
    #     ])
    #   end
    # end
  end
end
