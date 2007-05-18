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
      if result.success? and result.interval.end == input.size
        return result
      else
        return ParseFailure.new(result.interval.end)
      end
    end
    
    def node_cache_for(parsing_expression)
      parse_cache[parsing_expression]
    end
  end
end