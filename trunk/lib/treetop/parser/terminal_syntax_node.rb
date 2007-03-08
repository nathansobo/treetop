module Treetop
  class TerminalSyntaxNode < SyntaxNode
    def epsilon?
      text_value.eql? ""
    end
    
    def nested_failures
      []
    end
  end
end