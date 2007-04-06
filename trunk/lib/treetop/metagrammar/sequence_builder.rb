module Treetop
  class SequenceBuilder < ParsingExpressionBuilder
    def build
      choice(sequence, :primary)
    end
    
    def sequence
      two_or_more_delimited(:primary, :space) do
        def value(grammar)
          Sequence.new(element_values(grammar))
        end
        
        def element_values(grammar)
          elements.collect { |element| element.value(grammar) }
        end
      end
    end
        
  end
end