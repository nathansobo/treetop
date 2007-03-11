module Treetop
  class AndPredicate < Predicate
    def parse_at(input, start_index, parser)
      result = expression.parse_at(input, start_index, parser)
      
      if result.success?        
        return success_at(start_index, input, result.nested_failures)
      else
        return failure_at(start_index, [result])
      end
    end
    
    def to_s
      "&(#{expression.to_s})"
    end
  end
end