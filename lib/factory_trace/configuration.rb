module FactoryTrace
  class Configuration
    attr_accessor :path, :enabled, :color

    def initialize
      @enabled = ENV.key?('FB_TRACE') || ENV.key?('FB_TRACE_FILE')
      @path = ENV['FB_TRACE_FILE']
      @color = path.nil?
    end

    def out
      return STDOUT unless path

      File.open(path, 'w')
    end
  end
end
