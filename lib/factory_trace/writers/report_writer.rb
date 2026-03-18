# frozen_string_literal: true

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
        used: "used",
        unused: "unused"
      }.freeze

      # @param [Array<Hash>] results
      # @param [Symbol] kind - :factory (default) or :fixture
      def write(results, kind:)
        io.puts("")

        total_color = (results.any? { |result| result[:code] == :unused && !result.key?(:value) }) ? :red : :green

        results.each do |result|
          io.puts(convert(result, total_color: total_color, kind: kind))
        end
      end

      private

      # @param [Hash<Symbol, Object>] result
      # @param [Symbol] total_color
      # @param [Symbol] kind - :factory_bot or :fixtures
      def convert(result, total_color:, kind:)
        if result[:value]
          label = (kind == :fixtures) ? "fixture sets & entries" : "factories & traits"
          colorize(total_color, "total number of unique #{humanize_code(result[:code])} #{label}: #{result[:value]}")
        elsif result[:factory_names] && result[:trait_name]
          if kind == :fixtures
            append_definition_path(result) { "#{humanize_code(result[:code])} fixture entry #{colorize(:blue, result[:trait_name])} of fixture set #{list(result[:factory_names])}" }
          else
            append_definition_path(result) { "#{humanize_code(result[:code])} trait #{colorize(:blue, result[:trait_name])} of factory #{list(result[:factory_names])}" }
          end
        elsif result[:factory_names]
          if kind == :fixtures
            append_definition_path(result) { "#{humanize_code(result[:code])} fixture set #{list(result[:factory_names])}" }
          else
            append_definition_path(result) { "#{humanize_code(result[:code])} factory #{list(result[:factory_names])}" }
          end
        else
          append_definition_path(result) { "#{humanize_code(result[:code])} global trait #{colorize(:blue, result[:trait_name])}" }
        end
      end

      def colorize(color, msg)
        return msg unless configuration.color

        "#{COLORS[color]}#{msg}\e[0m"
      end

      def append_definition_path(result)
        msg = yield
        return msg unless configuration.trace_definition? && result[:definition_path]

        "#{msg} => #{result[:definition_path]}"
      end

      def humanize_code(code)
        CODES[code]
      end

      def list(elements, color: :blue)
        elements.map { |element| colorize(color, element) }.join(", ")
      end
    end
  end
end
