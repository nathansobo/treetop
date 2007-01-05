module Treetop
  class Parser
    attr_accessor :grammar
    
    def initialize(grammar)
      self.grammar = grammar
    end
    
    def parse(input)
      result = grammar.root.parse_at(input, 0, self)
      if result.success? and result.interval.end != input.size
        return ParseFailure.new(result.interval.end)
      else
        return result
      end
    end
  end
end