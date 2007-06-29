module Treetop
  class TerminalParsingExpression < NodeInstantiatingParsingExpression
    def initialize(node_class = nil)
      super
    end
      
    def node_superclass
      TerminalSyntaxNode
    end
  end
end