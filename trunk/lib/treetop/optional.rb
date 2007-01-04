module Treetop
  class Optional < OrderedChoice
    def initialize(optional_expression)
      super([optional_expression, TerminalSymbol.new("")])
    end
  end
end