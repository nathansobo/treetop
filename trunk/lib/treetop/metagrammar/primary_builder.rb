module Treetop
  class PrimaryBuilder < ParsingExpressionBuilder
    def build
      choice parenthesized_ordered_choice,
             :terminal_symbol,
             :nonterminal_symbol
    end
        
    def parenthesized_ordered_choice
      seq('(', optional(:space), :ordered_choice, optional(:space), ')') do
        def value(grammar)
          nested_expression.value(grammar)
        end

        def nested_expression
          elements[2]
        end
      end
    end
  end
end