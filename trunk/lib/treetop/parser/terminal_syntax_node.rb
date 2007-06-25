module Treetop
  class TerminalSyntaxNode < SyntaxNode
    
    def epsilon?
      text_value.eql? ""
    end
  end
end