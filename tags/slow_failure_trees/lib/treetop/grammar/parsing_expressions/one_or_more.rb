module Treetop
  class OneOrMore < RepeatingParsingExpression
    
    def enough?(results)
      !results.empty?
    end
    
    def to_s
      "(#{repeated_expression.to_s})+"
    end
  end
end