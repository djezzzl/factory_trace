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

    context "when kind is :fixture" do
      let(:fixture_results) do
        [
          {code: :used, value: 1},
          {code: :unused, value: 2},
          {code: :unused, factory_names: ["users"], trait_name: "one"},
          {code: :unused, factory_names: ["companies"]}
        ]
      end

      it "prints fixture-specific labels" do
        printer.write(fixture_results, kind: :fixture)

        expect(output.string).to eq(<<~TEXT)
          \e[31mtotal number of unique used fixture sets & entries: 1\e[0m
          \e[31mtotal number of unique unused fixture sets & entries: 2\e[0m
          unused fixture entry \e[34mone\e[0m of fixture set \e[34musers\e[0m
          unused fixture set \e[34mcompanies\e[0m
        TEXT
      end
    end
  end
end
