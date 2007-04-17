module Treetop
  class ZeroOrMore < RepeatingParsingExpression
    def enough?(results)
      true
    end
    
    def to_s
      "(#{repeated_expression.to_s})*"
    end
  end
end