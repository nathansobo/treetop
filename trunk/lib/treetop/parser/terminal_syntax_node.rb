module Treetop
  class TerminalSyntaxNode < SyntaxNode
    
    attr_reader :expression
    
    def initialize(expression, input, interval, nested_results = [])
      super(input, interval, nested_results)
      @expression = expression
    end
    
    def epsilon?
      text_value.eql? ""
    end
  end
end