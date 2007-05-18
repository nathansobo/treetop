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
  end
end