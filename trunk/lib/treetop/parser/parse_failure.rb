module Treetop
  class ParseFailure
    attr_reader :index, :nested_failures
    
    def initialize(index, nested_failures = [])
      @index = index
      @nested_failures = select_failures_at_maximum_index(nested_failures)
    end
    
    def success?
      false
    end
    
    def failure?
      true
    end
    
    def interval      
      @interval ||= (index...index)
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