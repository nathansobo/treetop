module Treetop
  class ZeroOrMore < RepeatingParsingExpression
    def to_s
      "(#{repeated_expression.to_s})*"
    end
  end
end