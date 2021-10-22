# frozen_string_literal: true

RSpec.describe FactoryTrace::Writers::ReportWriter do
  subject(:printer) { described_class.new(output) }

  describe "#print" do
    let(:output) { StringIO.new }
    let(:results) do
      [
        {code: :used, value: 1},
        {code: :unused, value: 3},
        {code: :unused, factory_names: [:admin], trait_name: :with_email},
        {code: :unused, factory_names: [:company]},
        {code: :unused, trait_name: :with_address}
      ]
    end

    it "prints the result" do
      printer.write(results)

      expect(output.string).to eq(<<~TEXT)
        \e[31mtotal number of unique used factories & traits: 1\e[0m
        \e[31mtotal number of unique unused factories & traits: 3\e[0m
        unused trait \e[34mwith_email\e[0m of factory \e[34madmin\e[0m
        unused factory \e[34mcompany\e[0m
        unused global trait \e[34mwith_address\e[0m
      TEXT
    end
  end
end
