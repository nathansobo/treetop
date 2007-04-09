module Treetop
  class PrimaryExpressionBuilder < ParsingExpressionBuilder
    def build
      seq(optional(:prefix), rest) do        
        def value(grammar)
          if prefix.epsilon?
            rest.value(grammar)
          else
            prefix.value(rest.value(grammar))
          end
        end
        
        def prefix
          elements[0]
        end
        
        def rest
          elements[1]
        end
      end
    end
  
    def rest
      seq(primary_expression, optional(:suffix)) do
        def value(grammar)
          if suffix.epsilon?
            primary_expression.value(grammar)
          else
            suffix.value(primary_expression.value(grammar))
          end
        end
    
        def primary_expression
          elements[0]
        end
    
        def suffix
          elements[1]
        end
      end
    end
    
    def primary_expression
      choice parenthesized_ordered_choice,
             :terminal_symbol,
             :nonterminal_symbol
    end
        
    def parenthesized_ordered_choice
      seq('(', optional(:space), :ordered_choice, optional(:space), ')', :trailing_block) do
        def value(grammar)
          nested_value = nested_expression.value(grammar)
          unless trailing_block.epsilon? || nested_value.kind_of?(NodeInstantiatingParsingExpression)
            raise "Blocks can only follow node-instantiating parsing expressions such as sequences and terminal symbols."
          end
          return trailing_block.value(nested_expression.value(grammar))
        end

        def nested_expression
          elements[2]
        end
        
        def trailing_block
          elements[5]
        end
      end
    end
  end
end