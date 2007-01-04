module Treetop
  class NotPredicate < Predicate
    def parse_at(input, start_index, parser)
      if super(input, start_index, parser)
        return failure_at(start_index)
      else
        return success_at(start_index, input)
      end
    end
  end
end