module Treetop
  class ParsingRuleSequenceBuilder < ParsingExpressionBuilder
    def build
      seq = delimited_sequence_of_zero_or_more(:parsing_rule, :space) do
        def value(grammar)
          element_values(grammar)
        end
      end
    end
  end
end

