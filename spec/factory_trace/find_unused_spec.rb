RSpec.describe FactoryTrace::FindUnused do
  subject(:checker) { described_class.new(data) }

  describe 'check!' do
    context 'when all factories are not used' do
      let(:data) { {} }

      it 'returns everything' do
        expect(checker.check!).to eq([
          {code: :used, value: 0},
          {code: :unused, value: 4},
          {code: :unused, factory: find_factory(:user)},
          {code: :unused, factory: find_factory(:admin)},
          {code: :unused, factory: find_factory(:company)},
          {code: :unused, trait: find_global_trait(:with_address)}
        ])
      end
    end

    context 'when a factory was used' do
      let(:data) { {user: Set.new} }

      it 'returns except used and for used returns all traits' do
        expect(checker.check!).to eq([
          {code: :used, value: 1},
          {code: :unused, value: 4},
          {code: :unused, factory: find_factory(:user), trait: find_trait(:user, :with_phone)},
          {code: :unused, factory: find_factory(:admin)},
          {code: :unused, factory: find_factory(:company)},
          {code: :unused, trait: find_global_trait(:with_address)}
        ])
      end
    end

    context 'when a factory was used with its trait' do
      let(:data) { {user: Set.new([:with_phone])} }

      it 'returns except used and for used returns all traits' do
        expect(checker.check!).to eq([
          {code: :used, value: 2},
          {code: :unused, value: 3},
          {code: :unused, factory: find_factory(:admin)},
          {code: :unused, factory: find_factory(:company)},
          {code: :unused, trait: find_global_trait(:with_address)}
        ])
      end
    end

    context 'when a child trait was used with parent' do
      let(:data) { {user: [], admin: []} }

      it 'returns except used and returns parents trait only with parent factory' do
        expect(checker.check!).to eq([
          {code: :used, value: 2},
          {code: :unused, value: 4},
          {code: :unused, factory: find_factory(:user), trait: find_trait(:user, :with_phone)},
          {code: :unused, factory: find_factory(:admin), trait: find_trait(:admin, :with_email)},
          {code: :unused, factory: find_factory(:company)},
          {code: :unused, trait: find_global_trait(:with_address)}
        ])
      end
    end

    context 'when a global trait was used' do
      let(:data) { {user: Set.new([:with_address])} }

      it 'returns except used and global trait' do
        expect(checker.check!).to eq([
          {code: :used, value: 2},
          {code: :unused, value: 3},
          {code: :unused, factory: find_factory(:user), trait: find_trait(:user, :with_phone)},
          {code: :unused, factory: find_factory(:admin)},
          {code: :unused, factory: find_factory(:company)}
        ])
      end
    end

    context 'when a parent trait was used' do
      let(:data) { {admin: Set.new([:with_phone])} }

      it 'returns except that factory and parent trait' do
        expect(checker.check!).to eq([
          {code: :used, value: 2},
          {code: :unused, value: 3},
          {code: :unused, factory: find_factory(:admin), trait: find_trait(:admin, :with_email)},
          {code: :unused, factory: find_factory(:company)},
          {code: :unused, trait: find_global_trait(:with_address)}
        ])
      end
    end

    context 'when everything were used' do
      let(:data) { {admin: Set.new([:with_phone, :with_email]), company: Set.new([:with_address])} }

      it 'returns nothing' do
        expect(checker.check!).to eq([
          {code: :used, value: 5},
          {code: :unused, value: 0},
        ])
      end
    end
  end
end
