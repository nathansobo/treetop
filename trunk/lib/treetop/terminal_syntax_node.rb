module Treetop
  class TerminalSyntaxNode < SyntaxNode
    attr_reader :input, :interval
    
    def initialize(input, interval)
      @input = input
      @interval = interval
    end
    
    def text_value
      input[interval]
    end
  end
end