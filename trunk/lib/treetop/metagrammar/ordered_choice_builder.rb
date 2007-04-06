module Treetop
  class OrderedChoiceBuilder < ParsingExpressionBuilder
    def build
      choice(ordered_choice, :sequence)
    end
    
    def ordered_choice
      two_or_more_delimited(:sequence, seq(:space, "/", :space)) do
        def value(grammar)
          OrderedChoice.new(element_values(grammar))
        end
        
        def element_values(grammar)
          elements.collect { |element| element.value(grammar) }
        end
      end
    end
  end
end