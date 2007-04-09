module Treetop
  class Protometagrammar
    class SuffixExpressionBuilder < ParsingExpressionBuilder
      def build
        choice(zero_or_more_terminal, one_or_more_terminal, optional)
      end
    
      def zero_or_more_terminal
        exp('*') do
          def value(parsing_expression)
            parsing_expression.zero_or_more
          end
        end
      end

      def one_or_more_terminal
        exp('+') do
          def value(parsing_expression)
            parsing_expression.one_or_more
          end          
        end
      end
    
      def optional
        exp('?') do
          def value(parsing_expression)
            parsing_expression.optional
          end
        end
      end
    
      def value(parsing_expression)
      end
    end
  end
end