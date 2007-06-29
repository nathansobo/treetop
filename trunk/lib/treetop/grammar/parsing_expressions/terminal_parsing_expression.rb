module Treetop
  class TerminalParsingExpression < NodeInstantiatingParsingExpression
    def node_superclass
      TerminalSyntaxNode
    end
  end
end