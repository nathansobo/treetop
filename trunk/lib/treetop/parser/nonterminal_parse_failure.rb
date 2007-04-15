module Treetop
  class NonterminalParseFailure < ParseFailure
    def matched_interval
      matched_interval_begin...(nested_failures.first.matched_interval.end)
    end
  end
end