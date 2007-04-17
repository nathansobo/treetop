module Treetop
  class Predicate < NodePropagatingParsingExpression
    attr_reader :expression
    
    def initialize(expression)
      @expression = expression
    end
    
    protected
    
    def success_at(index, input, nested_failures)
      return SyntaxNode.new(input, index...index, nested_failures)
    end
  end
end