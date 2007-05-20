module Treetop
  class TerminalParsingExpression < NodeInstantiatingParsingExpression
    def initialize
      super
    end
      
    def node_superclass
      TerminalSyntaxNode
    end
  end
end