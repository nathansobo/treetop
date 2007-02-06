module Treetop
  class OrderedChoiceBuilder < ParsingExpressionBuilder
    def build
      delimited_sequence(:primary, seq(:whitespace, "/", :whitespace)) do
        def value(grammar)
          OrderedChoice.new(element_values(grammar))
        end
      end
    end
  end
end