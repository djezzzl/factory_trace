RSpec.describe FactoryTrace::Preprocessors::ExtractUsed do
  describe '.call' do
    subject { described_class.call({'admin' => { traits: Set.new(['with_address']), alias_names: Set.new }}) }

    specify do
      collection = FactoryTrace::Structures::Collection.new(
        {
          'admin' => FactoryTrace::Structures::Factory.new('admin', nil, ['with_address'])
        },
        {}
      )
      expect(subject).to eq(collection)
    end
  end
end
