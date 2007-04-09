module Treetop
  class ParsingRuleSequenceExpressionBuilder < ParsingExpressionBuilder
    def build
      zero_or_more_delimited(:parsing_rule, :space) do
        def value(grammar)
          elements.collect {|element| element.value(grammar) }
        end
      end
    end
  end
end

