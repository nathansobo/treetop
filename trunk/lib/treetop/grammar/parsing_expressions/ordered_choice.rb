module Treetop
  class OrderedChoice < NodePropagatingParsingExpression
    attr_reader :alternatives
    
    def initialize(alternatives)
      @alternatives = alternatives
    end
    
    def to_s
      parenthesize((alternatives.collect {|alt| alt.to_s}).join(" / "))
    end
    
    def parse_at(input, start_index, parser)
      failures = []
      for alt in alternatives
        result = alt.parse_at(input, start_index, parser)
        if result.success?
          result.update_nested_failures(collect_nested_failures(failures))
          return result
        else
          failures << result
        end
      end
      return failure_at(start_index, failures)
    end
  end
end