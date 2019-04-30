require 'tempfile'

RSpec.describe FactoryTrace::TraceReader do
  subject(:reader) { described_class.new(input) }

  describe '.read_from_files' do
    let(:file1) { Tempfile.new('file1.txt') }
    let(:file2) { Tempfile.new('file2.txt') }

    before do
      file1.write("user,with_phone\nadmin\ncompany,with_phone,with_email\nmanager")
      file2.write("user\nsales\nadmin,with_name\ncompany,with_phone,with_email")
      file1.rewind
      file2.rewind
    end

    it 'reads' do
      expect(described_class.read_from_files(file1, file2)).to eq({
        admin: Set.new([:with_name]),
        company: Set.new([:with_phone, :with_email]),
        manager: Set.new,
        sales: Set.new,
        user: Set.new([:with_phone])
      })
    end
  end

  describe '#read' do
    let(:input) { StringIO.new("user,with_phone\nadmin\ncompany,with_phone,with_email") }

    it 'reads' do
      expect(reader.read).to eq({
        user: Set.new([:with_phone]),
        admin: Set.new,
        company: Set.new([:with_phone, :with_email])
      })
    end
  end
end
