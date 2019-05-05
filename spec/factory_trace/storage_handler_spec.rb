RSpec.describe FactoryTrace::StorageHandler do
  describe '.prepare' do
    subject { described_class.prepare(data) }

    let(:data) do
      {
        company: Set.new([:with_address]),
        admin: Set.new([:with_phone])
      }
    end

    it 'moves traits to its owners' do
      expect(subject).to eq([
        {
          '_traits' => Set.new(['with_address']),
          'admin' => Set.new(['with_email']),
          'user' => Set.new(['with_phone']),
          'company' => Set.new([])
        },
        {
          '_traits' => Set.new(['with_address']),
          'admin' => Set.new,
          'company' => Set.new,
          'user' => Set.new(['with_phone'])
        }
      ])
    end
  end
end
