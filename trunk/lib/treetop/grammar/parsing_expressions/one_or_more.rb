module Treetop
  class OneOrMore < RepeatingParsingExpression
    def parse_at(input, start_index, parser)
      result = super
      if result.empty?
        return failure_at(start_index)
      else
        return result
      end
    end
    
    def to_s
      "(#{repeated_expression.to_s})+"
    end
  end
end