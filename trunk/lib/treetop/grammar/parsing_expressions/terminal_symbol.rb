module Treetop
  class TerminalSymbol < NodeInstantiatingParsingExpression
    attr_accessor :prefix, :prefix_regex
    
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
        
    def to_s
      "\"#{prefix}\""
    end
    
    protected
    def parse_at_without_caching(input, start_index, parser)
      match = prefix_regex.match(input[start_index...(input.length)])
      if match
        return node_class.new(input, start_index...(match.end(0) + start_index))
      else
        failure_at(start_index)
      end
    end
  end
end