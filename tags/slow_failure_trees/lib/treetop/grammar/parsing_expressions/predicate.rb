module Treetop
  class Predicate < NodePropagatingParsingExpression
    attr_reader :expression
    
    def initialize(expression)
      @expression = expression
    end
    
    protected
    
    def success_at(index, input, result_of_expression)
      syntax_node = SyntaxNode.new(input, index...index)
      success(syntax_node, [result_of_expression])
    end
  end
end