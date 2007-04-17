module Treetop
  class SuccessfulParseResult
    attr_reader :value
    
    def initialize(value)
      @value = value
    end
    
    def success?
      true
    end
    
    def failure?
      false
    end
  end
end