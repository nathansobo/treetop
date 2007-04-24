module Treetop
  class RepeatingParsingExpression < Sequence
    attr_reader :repeated_expression
    
    def initialize(repeated_expression)
      super
      @repeated_expression = repeated_expression
    end

    protected
    def parse_at_without_caching(input, start_index, parser)
      results = []
      next_index = start_index

      while true
        result = repeated_expression.parse_at(input, next_index, parser)
        break if result.failure?
        results << result
        next_index = result.consumed_interval.end
      end
      
      if enough? results
        interval = start_index...next_index
        syntax_node = node_class.new(input, interval, results.collect(&:value))
        success(syntax_node, results + [result])
      else
        return failure_at(start_index)
      end
    end
  
  end
end