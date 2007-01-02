module Treetop
  class ZeroOrMore < CompositeParsingExpression
    attr_reader :repeated_expression
    
    def initialize(repeated_expression)
      @repeated_expression = repeated_expression
    end
    
    def parse_at(input, start_index, parser)
      results = []
      next_index = start_index
      loop do
        result = repeated_expression.parse_at(input, next_index, parser)
        break if result.instance_of? ParseFailure
        results << result
        next_index = result.interval.end
      end
      interval = start_index...next_index
      return SequenceSyntaxNode.new(input, interval, results)
    end
  end
end