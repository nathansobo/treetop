module Treetop
  class TerminalSymbol < NodeInstantiatingParsingExpression
    attr_accessor :prefix, :prefix_regex
    attr_reader :node_class
    
    def self.epsilon
      @epsilon ||= self.new("")
    end
    
    def initialize(prefix)
      super()
      self.prefix = prefix
      self.prefix_regex = /\A#{Regexp.escape(prefix)}/
    end
    
    def epsilon?
      prefix.blank?
    end
    
    def node_superclass
      TerminalSyntaxNode
    end
    
    def failure_at(index)
      TerminalParseFailure.new(index, self)
    end
    
    def to_s
      "\"#{prefix}\""
    end
    
    protected
    def parse_at_without_caching(input, start_index, parser)
      match = prefix_regex.match(input[start_index...(input.length)])
      if match
        match_interval = start_index...(match.end(0) + start_index)
        return node_class.new(input, match_interval)
      else
        return failure_at(start_index)
      end
    end
  end
end