module Treetop
  class FailedParseResult < ParseResult    
    attr_reader :expression, :index
    
    def initialize(expression, index)
      @expression = expression
      @index = index
    end
    
    def success?
      false
    end
    
    def failure?
      true
    end
    
    def interval
      @interval ||= (index...index)
    end
  end
end