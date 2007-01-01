module Treetop
  class NonterminalSymbol < AtomicParsingExpression
    attr_reader :name, :grammar
    
    def initialize(name, grammar)
      @name = name
      @grammar = grammar
    end
    
    def parse_at(input, start_index, parser)
      parsing_expression.parse_at(input, start_index, parser)
    end
    
    def parsing_expression
      grammar.get_parsing_expression(self)
    end
  end
end