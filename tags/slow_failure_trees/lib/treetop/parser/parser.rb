module Treetop
  class Parser
    attr_reader :grammar, :parse_cache
    
    def initialize(grammar)
      @grammar = grammar
      @parse_cache = ParseCache.new      
    end

    def parse(input)
      @parse_cache = ParseCache.new
      result = grammar.root.parse_at(input, 0, self)
      if result.success? and result.consumed_interval.end == input.size
        return result.value
      else
        failure_subtrees = result.failure_tree ? [result.failure_tree] : []
        return FailedParseResult.new(nil, result.consumed_interval.end, failure_subtrees)
      end
    end
    
    def node_cache_for(parsing_expression)
      parse_cache[parsing_expression]
    end
  end
end