module Treetop
  class AndPredicate
    attr_reader :expression
    
    def initialize(expression)
      @expression = expression
    end
    
    def parse_at(input, start_index, parser)
      result = expression.parse_at(input, start_index, parser)
      if result.instance_of? ParseFailure
        return result
      else
        interval = start_index...start_index
        return SyntaxNode.new(input, interval)
      end
    end
  end
end