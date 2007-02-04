module Treetop
  class ParsingRule
    attr_reader :nonterminal_symbol, :parsing_expression
    
    def initialize(nonterminal_symbol, parsing_expression)
      @nonterminal_symbol = nonterminal_symbol
      @parsing_expression = parsing_expression
    end
  end
end