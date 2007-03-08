module Treetop
  class TerminalParseFailure < ParseFailure
    def nested_failures
      []
    end
  end
end