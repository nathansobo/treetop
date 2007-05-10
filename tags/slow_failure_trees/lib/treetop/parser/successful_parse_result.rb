module Treetop
  class SuccessfulParseResult
    attr_reader :value, :failure_tree
    
    def initialize(expression, value, failure_subtrees)
      @value = value
      if failure_subtrees.empty?
        @failure_tree = nil
      else
        @failure_tree = FailureTree.new(expression, consumed_interval.begin, failure_subtrees)
      end
    end
    
    def success?
      true
    end
    
    def failure?
      false
    end
    
    def consumed_interval
      value.interval
    end
  end
end