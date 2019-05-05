RSpec.describe FactoryTrace::TraceWriter do
  subject(:printer) { described_class.new(output) }

  describe '#print' do
    let(:output) { StringIO.new }
    let(:all) do
      {
        user: Set.new([:with_phone]),
        admin: Set.new([:with_email]),
        company: Set.new([:with_address, :with_phone])
      }
    end

    let(:used) do
      {
        user: Set.new([:with_phone]),
        admin: Set.new([]),
        company: Set.new([:with_address, :with_phone])
      }
    end

    it 'prints the result' do
      printer.write([all, used])

      expect(output.string).to eq(<<~TEXT)
        -all-
        user,with_phone
        admin,with_email
        company,with_address,with_phone
        -used-
        user,with_phone
        admin,
        company,with_address,with_phone
      TEXT
    end
  end
end
