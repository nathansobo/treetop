module Treetop
  class SequenceBuilder < ParsingExpressionBuilder
    def build
      seq(one_or_more(sequence_element), :primary) do
        def value(grammar)
          elements = leading_elements(grammar) + [trailing_element(grammar)]
          Sequence.new(elements)
        end
        
        def leading_elements(grammar)
          elements[0].elements.map { |elt| elt.value(grammar) }
        end
        
        def trailing_element(grammar)
          elements[1].value(grammar)
        end
      end
    end
    
    def sequence_element
      seq(:primary, :whitespace) do
        def value(grammar)
          elements[0].value(grammar)
        end
      end
    end
  end
end