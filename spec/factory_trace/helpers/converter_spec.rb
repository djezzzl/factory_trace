RSpec.describe FactoryTrace::Helpers::Converter do
  describe '.trait' do
    context 'when has no owner' do
      subject { described_class.trait(trait) }

      let(:trait) { find_global_trait('with_address') }

      specify do
        expect(subject).to eq(FactoryTrace::Structures::Trait.new('with_address', nil))
      end
    end

    context 'when has owner' do
      subject { described_class.trait(trait, owner) }

      let(:trait) { find_trait('user', 'with_phone') }
      let(:owner) { find_factory('user') }

      specify do
        expect(subject).to eq(FactoryTrace::Structures::Trait.new('with_phone', 'user'))
      end
    end
  end

  describe '.factory' do
    context 'when has no aliases' do
      subject { described_class.factory(factory) }

      let(:factory) { find_factory('comment') }

      specify do
        expect(subject).to eq(FactoryTrace::Structures::Factory.new('user', nil, [], []))
      end
    end

    context 'when has aliases' do
      subject { described_class.factory(factory) }

      let(:factory) { find_factory('article') }

      specify do
        expect(subject).to eq(FactoryTrace::Structures::Factory.new('article', nil, [], ['post']))
      end
    end
  end
end
