module Treetop
  class ParsingRuleBuilder < ParsingExpressionBuilder
    def build
      seq('rule', :space, :nonterminal_symbol, :space, :ordered_choice, :space, 'end') do
        def value(grammar)
          ParsingRule.new(nonterminal_symbol.value(grammar),
                          parsing_expression.value(grammar))
        end
        
        def nonterminal_symbol
          elements[2]
        end
        
        def parsing_expression
          elements[4]
        end
      end
    end
    
    def nonnewline_space
      zero_or_more()
    end
  end
end

