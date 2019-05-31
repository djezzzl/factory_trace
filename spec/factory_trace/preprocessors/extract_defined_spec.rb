RSpec.describe FactoryTrace::Preprocessors::ExtractDefined do
  describe '.call' do
    subject { described_class.call }

    specify do
      collection = FactoryTrace::Structures::Collection.new(
        {
          'user' => FactoryTrace::Structures::Factory.new('user', nil, ['with_phone']),
          'admin' => FactoryTrace::Structures::Factory.new('admin', 'user', ['with_email']),
          'article' => FactoryTrace::Structures::Factory.new('article', nil, [], ['post']),
          'comment' => FactoryTrace::Structures::Factory.new('comment', nil, []),
          'company' => FactoryTrace::Structures::Factory.new('company', nil, [])
        },
        {
          'with_address' => FactoryTrace::Structures::Trait.new('with_address', nil)
        }
      )

      expect(subject).to eq(collection)
    end
  end
end
