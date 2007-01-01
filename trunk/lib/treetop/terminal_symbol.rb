module Treetop
  class TerminalSymbol < AtomicParsingExpression
    attr_accessor :prefix, :prefix_regex
    
    def initialize(prefix)
      self.prefix = prefix
      self.prefix_regex = /^#{Regexp.escape(prefix)}/
    end
    
    def parse_at(input, start_index, parser)
      match = prefix_regex.match(input[start_index...(input.length)])
      if match
        match_interval = start_index...match.end(0)
        return TerminalSyntaxNode.new(input, match_interval)
      end
    end
  end
end