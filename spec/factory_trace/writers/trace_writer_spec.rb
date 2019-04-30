RSpec.describe FactoryTrace::TraceWriter do
  subject(:printer) { described_class.new(output) }

  describe '#print' do
    let(:output) { StringIO.new }
    let(:results) do
      {
        user: Set.new([:with_phone]),
        admin: Set.new([]),
        company: Set.new([:with_address, :with_phone])
      }
    end

    it 'prints the result' do
      printer.write(results)

      expect(output.string).to eq(<<~TEXT)
        user,with_phone
        admin,
        company,with_address,with_phone
      TEXT
    end
  end
end
