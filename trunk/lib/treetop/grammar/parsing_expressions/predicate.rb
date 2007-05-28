module Treetop
  class Predicate < NodePropagatingParsingExpression
    attr_reader :expression
    
    def initialize(expression)
      @expression = expression
    end
        
    def parse_at(input, start_index, parser)
      result = expression.parse_at(input, start_index, parser)
      
      if result.success?
        return child_expression_success(start_index, input, result)
      else
        return child_expression_failure(start_index, input, result)
      end        
    end
    
    protected
    
    def success_at(index, input, nested_result)
      SyntaxNode.new(input, index...index, nested_result.nested_failures)
    end
  end
end