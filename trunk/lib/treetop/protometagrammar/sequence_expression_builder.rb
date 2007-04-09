module Treetop
  class SequenceExpressionBuilder < ParsingExpressionBuilder
    def build
      choice(sequence_with_block, :primary)
    end
    
    def sequence_with_block
      seq(sequence, :trailing_block) do
        def value(grammar)
          trailing_block.value(sequence.value(grammar))
        end
        
        def sequence
          elements[0]
        end
        
        def trailing_block
          elements[1]
        end
      end
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