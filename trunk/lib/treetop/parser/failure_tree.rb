module Treetop
  class FailureTree
    attr_reader :expression, :index, :subtrees, :max_subtree_index
    
    def initialize(expression, index, subtrees)
      @expression = expression
      @index = index
      @subtrees = select_by_max_subtree_index(subtrees)
    end
    
    protected
    def select_by_max_subtree_index(subtrees)    
      @max_subtree_index = index
      subtrees_with_max_index = []

      subtrees.each do |subtree|
        if subtree.max_subtree_index > @max_subtree_index
          @max_subtree_index = subtree.max_subtree_index
          subtrees_with_max_index = [subtree]
        elsif subtree.max_subtree_index == @max_subtree_index
          subtrees_with_max_index << subtree
        end
      end

      return subtrees_with_max_index
    end
  end
  
end