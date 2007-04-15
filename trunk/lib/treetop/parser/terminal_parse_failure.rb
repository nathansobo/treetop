module Treetop
  class TerminalParseFailure < ParseFailure
    def initialize(matched_interval_begin, expression)
      super(matched_interval_begin, expression, [])
    end
    
    def matched_interval
      consumed_interval
    end
    
  end
end