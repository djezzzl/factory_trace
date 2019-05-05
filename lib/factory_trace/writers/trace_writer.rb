module FactoryTrace
  class TraceWriter < Writer
    # @param [Array<Hash>] results
    def write(results)
      io.puts('-all-')
      output(results[0])
      io.puts('-used-')
      output(results[1])
    end

    private

    # @param [Hash<Symbol, Set<Hash>>] data
    def output(data)
      data.each do |key, set|
        line = [key, set.to_a.join(',')].join(',')
        io.puts(line)
      end
    end
  end
end
