RSpec.describe FactoryTrace::Preprocessors::ExtractUsed do
  describe '.call' do
    subject { described_class.call({'admin' => Set.new(['with_address'])}) }

    specify do
      collection = FactoryTrace::Structures::Collection.new(
        [
          FactoryTrace::Structures::Factory.new('admin', nil, ['with_address'], [])
        ],
        []
      )
      expect(subject).to eq(collection)
    end
  end
end
