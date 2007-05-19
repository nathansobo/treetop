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
    
    def to_s
      name.to_s
    end

    def parse_at(input, start_index, parser)
      result = parsing_expression.parse_at(input, start_index, parser)
      if result.success?
        result
      else
        return failure_at(start_index, result.nested_failures)
      end
    end
    
    protected
    
    def node_cache(parser)
      parser.node_cache_for(self)
    end
  end
end