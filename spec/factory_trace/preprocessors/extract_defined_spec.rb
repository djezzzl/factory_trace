RSpec.describe FactoryTrace::Preprocessors::ExtractDefined do
  describe '.call' do
    subject { described_class.call }

    specify do
      collection = FactoryTrace::Structures::Collection.new(
        [
          FactoryTrace::Structures::Factory.new('user', nil, ['with_phone'], []),
          FactoryTrace::Structures::Factory.new('admin', 'user', ['with_email'], []),
          FactoryTrace::Structures::Factory.new('company', nil, [], []),
          FactoryTrace::Structures::Factory.new('article', nil, [], ['post']),
          FactoryTrace::Structures::Factory.new('comment', nil, [], []),
        ],
        [
          FactoryTrace::Structures::Trait.new('with_address', nil)
        ]
      )

      expect(subject).to eq(collection)
    end
  end
end
