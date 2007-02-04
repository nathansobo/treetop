module Treetop
  class OneOrMore < RepeatingParsingExpression
    def parse_at(input, start_index, parser)
      result = super
      if result.empty?
        return ParseFailure.new(start_index)
      else
        return result
      end
    end
  end
end