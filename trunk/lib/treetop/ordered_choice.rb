module Treetop
  class OrderedChoice < CompositeParsingExpression
    attr_reader :alternatives
    
    def initialize(alternatives)
      @alternatives = alternatives
    end
    
    def parse_at(input, start_index, parser)
      for alt in alternatives
        result = alt.parse_at(input, start_index, parser)
        return result if !result.is_a?(ParseFailure)
      end
      return ParseFailure.new(start_index)
    end
  end
end