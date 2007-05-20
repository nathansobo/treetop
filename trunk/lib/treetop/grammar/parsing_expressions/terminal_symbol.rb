module Treetop
  class TerminalSymbol < TerminalParsingExpression
    attr_accessor :prefix
    
    def self.epsilon
      @epsilon ||= self.new("")
    end
    
    def initialize(prefix)
      super()
      self.prefix = prefix
    end
    
    def epsilon?
      prefix.blank?
    end
            
    def to_s
      "\"#{prefix}\""
    end
    
    def parse_at(input, start_index, parser)
      
      if input.index(prefix, start_index) == start_index
        return node_class.new(input, start_index...(prefix.length + start_index))
      else
        TerminalParseFailure.new(start_index, self)
      end
    end
  end
end