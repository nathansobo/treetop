module Treetop
  class FailureLeaf < FailureTree
    def initialize(expression, index)
      super(expression, index, [])
    end
  end
end