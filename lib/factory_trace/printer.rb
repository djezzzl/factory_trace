module FactoryTrace
  class Printer
    def initialize(io)
      @io = io
    end

    # @param [Array<Hash>] results
    def print(results)
      results.each do |result|
        io.puts(convert(result))
      end
    end

    private

    # @param [Hash<Symbol, Object>] result
    def convert(result)
      case
      when result[:value]
        "total number of unique #{result[:code]} factories & traits: #{result[:value]}"
      when result[:factory] && result[:trait]
        "#{result[:code]} trait '#{result[:trait].name}' of factory '#{result[:factory].name}'"
      when result[:factory]
        "#{result[:code]} factory '#{result[:factory].name}'"
      else
        "#{result[:code]} global trait '#{result[:trait].name}'"
      end
    end

    attr_reader :io
  end
end
