RSpec.describe FactoryTrace::Printer do
  subject(:printer) { described_class.new(output) }

  describe '#print' do
    let(:output) { StringIO.new }
    let(:results) do
      [
        {code: :unused, factory: find_factory(:admin), trait: find_trait(:admin, :with_email)},
        {code: :unused, factory: find_factory(:company)},
        {code: :unused, trait: find_global_trait(:with_address)}
      ]
    end

    it 'prints the result' do
      printer.print(results)

      expect(output.string).to eq(<<~TEXT)
        unused trait 'with_email' of factory 'admin'
        unused factory 'company'
        unused global trait 'with_address'
      TEXT
    end
  end
end
