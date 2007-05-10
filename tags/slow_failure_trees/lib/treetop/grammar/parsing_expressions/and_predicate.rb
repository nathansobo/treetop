module Treetop
  class AndPredicate < Predicate    
    def to_s
      "&(#{expression.to_s})"
    end
    
    protected
    def parse_at_without_caching(input, start_index, parser)
      result = expression.parse_at(input, start_index, parser)
      
      if result.success?        
        return success_at(start_index, input, result)
      else
        return failure_at(start_index, [result])
      end
    end
  end
end