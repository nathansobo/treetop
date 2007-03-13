module Treetop
  class SequenceBuilder < ParsingExpressionBuilder
    def build
      choice(sequence, :primary)
    end
    
    def sequence
      delimited_sequence(:primary, :space) do
        def value(grammar)
          Sequence.new(element_values(grammar))
        end
      end
    end
        
  end
end