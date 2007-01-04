module Treetop
  class Optional < OrderedChoice
    attr_reader :expression
    
    def initialize(optional_expression)
      super([optional_expression, TerminalSymbol.epsilon])
      @expression = optional_expression
    end
  end
end