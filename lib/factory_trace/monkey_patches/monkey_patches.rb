module FactoryTrace
  module MonkeyPatches
    REGISTER = FactoryBot::VERSION >= '5.1.0' ? FactoryBot::Internal : FactoryBot
  end
end
