module FactoryTrace
  class Configuration
    attr_accessor :path, :enabled, :color, :mode, :trace_definition

    def initialize
      @enabled = ENV.key?("FB_TRACE") || ENV.key?("FB_TRACE_FILE")
      @path = ENV["FB_TRACE_FILE"]
      @color = path.nil?
      @mode = extract_mode(ENV["FB_TRACE"]) || :full
      @trace_definition = true
    end

    def trace_definition?
      @trace_definition
    end

    def out
      return $stdout unless path

      File.open(path, "w")
    end

    def mode?(*args)
      args.include?(mode)
    end

    private

    def extract_mode(value)
      matcher = value&.match(/full|trace_only/)
      matcher && matcher[0].to_sym
    end
  end
end
