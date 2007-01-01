module Treetop
  class Parser
    attr_accessor :grammar
    
    def initialize(grammar)
      self.grammar = grammar
    end
  end
end