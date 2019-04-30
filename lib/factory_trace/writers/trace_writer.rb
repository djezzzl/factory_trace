module FactoryTrace
  class TraceWriter < Writer
    # @param [Hash<Symbol, Set<Hash>>] results
    def write(results)
      results.each do |key, set|
        line = [key, set.to_a.join(',')].join(',')
        io.puts(line)
      end
    end
  end
end
