module Treetop
  class OrderedChoiceBuilder < ParsingExpressionBuilder
    def build
      seq(one_or_more(choice_element), :primary) do
        def value(grammar)
          alternatives = leading_alternatives(grammar) + [trailing_alternative(grammar)]
          OrderedChoice.new(alternatives)
        end
        
        def leading_alternatives(grammar)
          elements[0].elements.map { |elt| elt.value(grammar) }
        end
        
        def trailing_alternative(grammar)
          elements[1].value(grammar)
        end
      end
    end
    
    def choice_element
      seq(:primary, :whitespace, "/", :whitespace) do
        def value(grammar)
          elements[0].value(grammar)
        end
      end
    end
  end
end