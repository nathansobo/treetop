module Treetop
  class NotPredicate < Predicate
    def to_s
      "!(#{expression.to_s})"
    end
    
    protected
    
    def child_expression_success(index, input, result)
      return failure_at(index, [result])
    end
    
    def child_expression_failure(index, input, result)
      return success_at(index, input, result)
    end
    
  end
end