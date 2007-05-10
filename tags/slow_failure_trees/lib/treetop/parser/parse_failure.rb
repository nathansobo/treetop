module Treetop
  class ParseFailure
    attr_reader :parsing_expression, :interval, :nested_failures, :matched_interval_begin
    
    def initialize(matched_interval_begin, parsing_expression, nested_failures = [])
      @parsing_expression = parsing_expression
      @matched_interval_begin = matched_interval_begin
      @nested_failures = select_nested_failures_with_maximum_matched_interval_ends(nested_failures)
      @interval = matched_interval_begin...matched_interval_begin
    end
    
    def success?
      false
    end
    
    def failure?
      true
    end
    
    private
    def select_nested_failures_with_maximum_matched_interval_ends(nested_failures)
      max = 0
      results = []
      nested_failures.each do |nested_failure|
        matched_interval_end = nested_failure.matched_interval.end
        if matched_interval_end > max
          results = [nested_failure]
          max = matched_interval_end
        elsif matched_interval_end == max
          results << nested_failure
        end
      end
      results
    end
  end
end