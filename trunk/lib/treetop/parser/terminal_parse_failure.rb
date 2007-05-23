module Treetop
  class TerminalParseFailure < ParseFailure
    attr_reader :expression

    def initialize(index, expression)
      super(index)
      @expression = expression      
    end
    
    def nested_failures
      [self]
    end
    
    def to_s
      "String matching #{expression} expected at position #{index}."
    end
  end
end