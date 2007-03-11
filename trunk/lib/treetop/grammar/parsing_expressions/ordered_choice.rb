module Treetop
  class OrderedChoice < NodePropagatingParsingExpression
    attr_reader :alternatives
    
    def initialize(alternatives)
      @alternatives = alternatives
    end
    
    def parse_at(input, start_index, parser)
      failures = []
      
      for alt in alternatives
        result = alt.parse_at(input, start_index, parser)
        if result.failure?
          failures << result
        else
          result.nested_failures.push(*failures)
          return result
        end
      end
      return failure_at(start_index, failures)
    end
    
    def to_s
      parenthesize((alternatives.collect {|alt| alt.to_s}).join(" / "))
    end
  end
end