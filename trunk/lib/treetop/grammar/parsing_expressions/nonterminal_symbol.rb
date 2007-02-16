module Treetop
  class NonterminalSymbol < NodePropagatingParsingExpression
    attr_reader :name, :grammar
    
    def initialize(name, grammar)
      @name = name
      @grammar = grammar
    end
    
    def parse_at(input, start_index, parser)
      if cached_result = parser.node_cache.node_starting_at(start_index, self)
        return cached_result
      else
        result = parsing_expression.parse_at(input, start_index, parser)
        parser.node_cache.store_node(self, result)
        return result
      end
    end
    
    def parsing_expression
      grammar.get_parsing_expression(self)
    end
  end
end