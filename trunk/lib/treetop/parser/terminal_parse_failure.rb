module Treetop
  class TerminalParseFailure < ParseFailure
    def initialize(matched_interval_begin, expression)
      super(matched_interval_begin, expression, [])
    end
  end
end