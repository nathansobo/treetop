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
      failed_results = []
      for alt in alternatives
        result = alt.parse_at(input, start_index, parser)
        if result.success?
          return SuccessfulParseResult.new(self, result.value, collect_failure_subtrees(failed_results))
        else
          failed_results << result
        end
      end
      return failure_at(start_index, failed_results)
    end
  end
end