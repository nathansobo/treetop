module Treetop
  class Parser
    attr_accessor :grammar
    
    def initialize(grammar)
      self.grammar = grammar
    end
    
    def parse(input)
      grammar.root.parse_at(input, 0, self)
    end
  end
end