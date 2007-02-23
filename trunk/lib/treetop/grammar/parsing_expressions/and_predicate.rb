module Treetop
  class AndPredicate < Predicate
    def parse_at(input, start_index, parser)
      if super(input, start_index, parser)
        return success_at(start_index, input)
      else
        return failure_at(start_index)
      end
    end
    
    def to_s
      "&(#{expression.to_s})"
    end
  end
end