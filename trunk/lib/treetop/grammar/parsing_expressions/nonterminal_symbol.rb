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

    protected
    def parse_at_without_caching(input, start_index, parser)
      result = parsing_expression.parse_at(input, start_index, parser)
      
      if result.success?
        SuccessfulParseResult.new(self, result.value, collect_failure_subtrees([result]))
      else
        failure_at(start_index, [result])
      end
    end    
  end
end