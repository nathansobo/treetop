module Treetop
  class ParseResult
    attr_reader :nested_failures
    
    def initialize(nested_failures = [])
      @nested_failures = select_failures_at_maximum_index(nested_failures)
    end
    
    protected
    def select_failures_at_maximum_index(failures)
      maximum_index = 0
      failures_at_maximum_index = []
      
      failures.each do |failure|
        if failure.index > maximum_index
          failures_at_maximum_index = [failure]
          maximum_index = failure.index
        elsif failure.index == maximum_index
          failures_at_maximum_index << failure
        end
      end
      
      return failures_at_maximum_index
    end
  end
end