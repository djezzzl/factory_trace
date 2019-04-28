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
      suffix =
        case
        when result[:factory] && result[:trait]
          "trait '#{result[:trait].name}' of factory '#{result[:factory].name}'"
        when result[:factory]
          "factory '#{result[:factory].name}'"
        else
          "global trait '#{result[:trait].name}'"
        end
      "#{result[:code]} #{suffix}"
    end

    attr_reader :io
  end
end
