module Treetop
  class Predicate < NodePropagatingParsingExpression
    attr_reader :expression
    
    def initialize(expression)
      @expression = expression
    end
    
    protected
    
    def success_at(index, input, result_of_expression)
      failure_subtrees = [result_of_expression.failure_tree].compact
      return SuccessfulParseResult.new(self, SyntaxNode.new(input, index...index), failure_subtrees)
    end
  end
end