module Treetop
  class FailureTree
    attr_reader :expression, :index, :subtrees
    
    def initialize(expression, index, subtrees)
      @expression = expression
      @index = index
      @subtrees = subtrees
    end
  end
end