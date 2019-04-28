module FactoryTrace
  class Configuration
    attr_accessor :path, :enabled

    def initialize
      @enabled = true
      @path = nil
    end

    def out
      return STDOUT unless path

      File.open(path, 'w')
    end
  end
end
