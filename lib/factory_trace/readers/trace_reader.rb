require 'set'

module FactoryTrace
  class TraceReader
    def self.read_from_files(*file_names, config: Configuration.new)
      file_names.reduce({}) do |hash, file_name|
        reader = new(File.open(file_name, 'r'), config: config)
        hash.merge(reader.read) { |_key, v1, v2| v1 | v2 }
      end
    end

    def initialize(io, config: Configuration.new)
      @io = io
      @config = config
    end

    def read
      @data ||= {}

      io.each_line do |line|
        factory, *traits = line.strip.split(',').map(&:to_sym)

        if factory
          @data[factory] ||= Set.new
          @data[factory] |= traits
        end
      end

      @data
    end

    private

    attr_reader :io, :config
  end
end
