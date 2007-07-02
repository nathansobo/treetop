module Treetop
  class NonterminalSymbol < NodePropagatingParsingExpression
    attr_reader :name, :grammar
    
    def initialize(name, grammar)
      @name = name
      @grammar = grammar
    end
        
    def parsing_expression
      grammar.get_parsing_expression(self)
    end
    
    def label
      super || name
    end
    
    def to_s
      name.to_s
    end
    
    def ==(other_nonterminal)
      other_nonterminal.grammar == grammar && other_nonterminal.name == name
    end

    def parse_at(input, start_index, parser)
      node_cache = parser.parse_cache[self]
      if cached_result = node_cache[start_index]
        return cached_result
      else
        return node_cache.store(parse_at_without_caching(input, start_index, parser))
      end
    end
    
    protected
    def parse_at_without_caching(input, start_index, parser)
      result = grammar.get_parsing_expression(name).parse_at(input, start_index, parser)
      
      if result.success?
        result
      else
        return failure_at(start_index, result.nested_failures)
      end
    end
    
    def node_cache(parser)
      parser.node_cache_for(self)
    end
  end
end