module Treetop
  class OrderedChoiceBuilder < ParsingExpressionBuilder
    def build
      choice(ordered_choice, :sequence)
    end
    
    def ordered_choice
      delimited_sequence(:sequence, seq(:space, "/", :space)) do
        def value(grammar)
          OrderedChoice.new(element_values(grammar))
        end
      end
    end
  end
end