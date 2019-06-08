module FactoryTrace
  module Writers
    class ReportWriter < Writer
      COLORS = {
        blue: "\e[34m",
        yellow: "\e[33m",
        green: "\e[32m",
        red: "\e[31m"
      }.freeze

      CODES = {
        used: 'used',
        unused: 'unused',
      }.freeze

      # @param [Array<Hash>] results
      def write(results)
        total_color = results.any? { |result| result[:code] == :unused && !result.key?(:value) } ? :red : :green

        results.each do |result|
          io.puts(convert(result, total_color: total_color))
        end
      end

      private

      # @param [Hash<Symbol, Object>] result
      # @param [Symbol] total_color
      def convert(result, total_color:)
        case
        when result[:value]
          colorize(total_color, "total number of unique #{humanize_code(result[:code])} factories & traits: #{result[:value]}")
        when result[:factory_names] && result[:trait_name]
          "#{humanize_code(result[:code])} trait #{colorize(:blue, result[:trait_name])} of factory #{list(result[:factory_names])}"
        when result[:factory_names]
          "#{humanize_code(result[:code])} factory #{list(result[:factory_names])}"
        else
          "#{humanize_code(result[:code])} global trait #{colorize(:blue, result[:trait_name])}"
        end
      end

      def colorize(color, msg)
        return msg unless configuration.color

        "#{COLORS[color]}#{msg}\e[0m"
      end

      def humanize_code(code)
        CODES[code]
      end

      def list(elements, color: :blue)
        elements.map { |element| colorize(color, element) }.join(', ')
      end
    end
  end
end
