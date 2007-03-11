module Treetop
  class NotPredicate < Predicate
    def parse_at(input, start_index, parser)
      result = expression.parse_at(input, start_index, parser)
      
      if result.success?
        return failure_at(start_index, result.nested_failures)
      else
        return success_at(start_index, input, [result])
      end
    end

    def to_s
      "!(#{expression.to_s})"
    end
  end
end