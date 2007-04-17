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
      if result.success? and result.interval.end != input.size        
        return NonterminalParseFailure.new(result.interval.end, nil, result.nested_failures)
      else
        return result
      end
    end
    
    def node_cache_for(parsing_expression)
      parse_cache[parsing_expression]
    end
  end
end