require 'set'

module FactoryTrace
  class TraceReader
    # Read the data from files and merge it
    # First hash - all factories
    # Second hash - used factories
    #
    # @return [Array<Hash>]
    def self.read_from_files(*file_names, config: Configuration.new)
      file_names.reduce([{}, {}]) do |array, file_name|
        reader = new(File.open(file_name, 'r'), config: config)
        new = reader.read
        array.each_with_index.map do |hash, index|
          hash.merge(new[index]) { |_key, v1, v2| v1 | v2 }
        end
      end
    end

    def initialize(io, config: Configuration.new)
      @io = io
      @config = config
    end

    # Read the data from file
    # First hash - all factories
    # Second hash - used factories
    #
    # @return [Array<Hash>]
    def read
      data = [{}, {}]
      point = -1

      io.each_line do |line|
        next point += 1 if line.match?(/-all-|-used-/)

        factory, *traits = line.strip.split(',')

        if factory
          data[point][factory] ||= Set.new
          data[point][factory] |= traits
        end
      end

      data
    end

    private

    attr_reader :io, :config
  end
end
