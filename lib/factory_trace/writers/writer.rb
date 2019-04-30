module FactoryTrace
  class Writer
    def self.factory(io, config: Configuration.new)
      writer =
        if config.mode?(:full)
          ReportWriter
        elsif config.mode?(:trace_only)
          TraceWriter
        end

      writer.new(io, config: config)
    end

    def initialize(io, config: Configuration.new)
      @io = io
      @config = config
    end

    private

    attr_reader :io, :config
  end
end
