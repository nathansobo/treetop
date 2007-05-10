module Treetop
  class Predicate < NodePropagatingParsingExpression
    attr_reader :expression
    
    def initialize(expression)
      @expression = expression
    end
    
    protected
    
    def success_at(index, input)
      SyntaxNode.new(input, index...index)
    end
  end
end