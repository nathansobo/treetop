module Treetop
  class TerminalSymbol < NodeInstantiatingParsingExpression
    attr_accessor :prefix, :prefix_regex
    attr_reader :node_class
    
    def self.epsilon
      @epsilon ||= self.new("")
    end
    
    def initialize(prefix)
      @node_class = Class.new(TerminalSyntaxNode)
      self.prefix = prefix
      self.prefix_regex = /^#{Regexp.escape(prefix)}/
    end
    
    def parse_at(input, start_index, parser)
      match = prefix_regex.match(input[start_index...(input.length)])
      if match
        match_interval = start_index...(match.end(0) + start_index)
        return node_class.new(input, match_interval)
      else
        return ParseFailure.new(start_index)
      end
    end
    
    def node_class_eval(&block)
      node_class.class_eval &block
    end
  end
end