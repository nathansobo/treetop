module Treetop
  class OrderedChoice < NodePropagatingParsingExpression
    attr_reader :alternatives
    
    def initialize(alternatives)
      @alternatives = alternatives
    end
    
    def to_s
      parenthesize((alternatives.collect {|alt| alt.to_s}).join(" / "))
    end
    
    protected
    def parse_at_without_caching(input, start_index, parser)      
      for alt in alternatives
        result = alt.parse_at(input, start_index, parser)
        unless result.failure?
          return result
        end
      end
      return failure_at(start_index)
    end
  end
end