module Treetop
  class ParseFailure
    attr_reader :parsing_expression
    
    def initialize(matched_interval_begin, parsing_expression, nested_failures = [])
      @matched_interval_begin = matched_interval_begin
      @parsing_expression = parsing_expression
      @nested_failures = nested_failures
    end
    
    def success?
      false
    end
    
    def failure?
      true
    end
    
    def consumed_interval
      @matched_interval_begin...@matched_interval_begin
    end
    
    def matched_interval
      @matched_interval_begin...@matched_interval_begin
    end
  end
end