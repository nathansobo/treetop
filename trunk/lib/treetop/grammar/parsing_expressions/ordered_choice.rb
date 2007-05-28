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
      failed_results = []
      for alt in alternatives
        result = alt.parse_at(input, start_index, parser)
        if result.success?
          result.update_nested_failures(failed_results)
          return result
        else
          failed_results << result
        end
      end
      return failure_at(start_index, failed_results)
    end
  end
end