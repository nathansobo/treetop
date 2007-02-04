module Treetop
  class Predicate < NodePropagatingParsingExpression
    attr_reader :expression
    
    def initialize(expression)
      @expression = expression
    end
    
    protected
    def parse_at(input, start_index, parser)
      expression.parse_at(input, start_index, parser).success?
    end
    
    def failure_at(index)
      ParseFailure.new(index)
    end
    
    def success_at(index, input)      
      return SyntaxNode.new(input, index...index)
    end
  end
end