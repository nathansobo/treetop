module Treetop
  class AndPredicate
    attr_reader :expression
    
    def initialize(expression)
      @expression = expression
    end
    
    def parse_at(input, start_index, parser)
      result = expression.parse_at(input, start_index, parser)
      if result.success?
        interval = start_index...start_index
        return SyntaxNode.new(input, interval)
      else
        return result
      end
    end
  end
end