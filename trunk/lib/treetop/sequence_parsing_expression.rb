module Treetop
  class SequenceParsingExpression < CompositeParsingExpression
    attr_reader :elements
    
    def initialize(elements)
      @elements = elements
    end
    
    def parse_at(input, start_index, parser)
      results = []
      next_index = start_index
      
      for elt in elements
        result = elt.parse_at(input, next_index, parser)
        if result.is_a? ParseFailure
          return ParseFailure.new(start_index)
        else
          results << result
          next_index = result.interval.end
        end
      end
      
      interval = start_index...next_index
      return SequenceSyntaxNode.new(input, interval, results)
    end
  end
end