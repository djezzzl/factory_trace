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
        used_indirectly: 'used only indirectly'
      }.freeze

      # @param [Array<Hash>] results
      def write(results)
        total_color =
          if results.any? { |result| result[:code] == :unused }
            :red
          elsif results.any? { |result| result[:code] == :used_indirectly }
            :yellow
          else
            :green
          end

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
        when result[:factory_name] && result[:trait_name]
          "#{humanize_code(result[:code])} trait #{colorize(:blue, result[:trait_name])} of factory #{colorize(:blue, result[:factory_name])}"
        when result[:factory_name] && result[:factories_names]
          "#{humanize_code(result[:code])} factory #{colorize(:blue, result[:factory_name])} as parent for #{list(result[:factories_names])}"
        when result[:factory_name]
          "#{humanize_code(result[:code])} factory #{colorize(:blue, result[:factory_name])}"
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

      def list(elements)
        elements.map { |element| colorize(:blue, element) }.join(', ')
      end
    end
  end
end
