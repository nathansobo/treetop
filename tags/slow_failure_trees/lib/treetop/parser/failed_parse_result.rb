module Treetop
  class FailedParseResult < ParseResult
    attr_reader :failure_tree
    
    def initialize(expression, index, failure_subtrees)
      if failure_subtrees.empty?
        @failure_tree = FailureLeaf.new(expression, index)
      else
        @failure_tree = FailureTree.new(expression, index, failure_subtrees)
      end
    end
    
    def success?
      false
    end
    
    def failure?
      true
    end
    
    def consumed_interval
      @consumed_interval ||= (index...index)
    end
    
    def index
      @index ||= failure_tree.index
    end
  end
end