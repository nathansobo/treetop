module Treetop
  class NonterminalSymbol < NodePropagatingParsingExpression
    attr_reader :name, :grammar
    
    def initialize(name, grammar)
      @name = name
      @grammar = grammar
    end
    
    def parse_at(input, start_index, parser)
      node_cache = node_cache(parser)
      node_cache[start_index] || node_cache.store(parse_at_without_caching(input, start_index, parser))
    end
    
    def parse_at_without_caching(input, start_index, parser)
      parsing_expression.parse_at(input, start_index, parser)
    end
    
    def parsing_expression
      grammar.get_parsing_expression(self)
    end
    
    def to_s
      name.to_s
    end
  end
end