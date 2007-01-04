module Treetop
  class TerminalSymbol < AtomicParsingExpression
    attr_accessor :prefix, :prefix_regex
    
    def self.epsilon
      @epsilon ||= self.new("")
    end
    
    def initialize(prefix)
      self.prefix = prefix
      self.prefix_regex = /^#{Regexp.escape(prefix)}/
    end
    
    def parse_at(input, start_index, parser)
      match = prefix_regex.match(input[start_index...(input.length)])
      if match
        match_interval = start_index...(match.end(0) + start_index)
        return TerminalSyntaxNode.new(input, match_interval)
      else
        return ParseFailure.new(start_index)
      end
    end
  end
end