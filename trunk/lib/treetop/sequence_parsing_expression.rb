module Treetop
  class SequenceParsingExpression < CompositeParsingExpression
    attr_reader :elements
    
    def initialize(elements)
      @elements = elements
    end
    
    def parse_at(input, start_index, parser)
      next_index = start_index
      for elt in elements
        result = elt.parse_at(input, next_index, parser)
        return ParseFailure.new(start_index) if result.is_a? ParseFailure
        next_index = result.interval.end
      end
    end
  end
end