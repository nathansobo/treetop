module Treetop
  class PrefixBuilder < ParsingExpressionBuilder    
    def build
      choice(and_predicate, not_predicate)
    end
    
    def and_predicate
      exp('&') do
        def value(parsing_expression)
          parsing_expression.and_predicate
        end
      end
    end

    def not_predicate
      exp('!') do
        def value(parsing_expression)
          parsing_expression.not_predicate
        end
      end
    end
  end
end