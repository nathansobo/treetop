module Treetop
  class Predicate < NodePropagatingParsingExpression
    attr_reader :expression
    
    def initialize(expression)
      @expression = expression
    end
    
    protected
    
    def parse_at_without_caching(input, start_index, parser)
      result = expression.parse_at(input, start_index, parser)
      
      if result.success?
        return child_expression_success(start_index, input, result)
      else
        return child_expression_failure(start_index, input, result)
      end        
    end
    
    def success_at(index, input, nested_results)
      SyntaxNode.new(input, index...index, collect_nested_failures(nested_results))
    end
  end
end