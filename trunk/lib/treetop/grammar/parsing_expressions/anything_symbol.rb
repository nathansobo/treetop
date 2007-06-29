module Treetop
  class AnythingSymbol < TerminalParsingExpression
    def initialize(node_class = nil)
      super(node_class)
    end
    
    def parse_at(input, start_index, parser)
      if start_index < input.length
        interval = (start_index...(start_index + 1))
        return node_class.new(self, input, interval)
      else
        TerminalParseFailure.new(self, start_index)
      end
    end
    
    def to_s
      '.'
    end
  end
end