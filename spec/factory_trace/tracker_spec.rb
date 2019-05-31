RSpec.describe FactoryTrace::Tracker do
  subject(:tracker) { described_class.new }

  describe '#track!' do
    before { tracker.track! }

    it 'collects used factories without traits' do
      build(:user)

      expect(tracker.storage).to eq('user' => { traits: Set.new, alias_names: Set.new })
    end

    it 'collects used factories with traits' do
      build(:user, :with_phone)

      expect(tracker.storage).to eq('user' => { traits: Set.new(['with_phone']), alias_names: Set.new })
    end

    it 'collects used factories with global traits' do
      build(:user, :with_address)

      expect(tracker.storage).to eq('user' => { traits: Set.new(['with_address']), alias_names: Set.new })
    end

    it 'collects used factories with alias' do
      build(:post)

      expect(tracker.storage).to eq(
        'article' => { traits: Set.new, alias_names: Set.new(['post']) },
        'user' => { traits: Set.new, alias_names: Set.new }
      )
    end

    it 'collects all used factories' do
      build(:user)
      build(:admin, :with_phone, :with_email)
      build(:company, :with_address)

      expect(tracker.storage).to eq(
        'user' => { traits: Set.new, alias_names: Set.new },
        'admin' => { traits: Set.new(['with_phone', 'with_email']), alias_names: Set.new },
        'company' => { traits: Set.new(['with_address']), alias_names: Set.new }
      )
    end
  end
end
