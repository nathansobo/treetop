module Treetop
  class TerminalParseFailure < ParseFailure
    def nested_failures
      []
    end
        
    def nested_terminal_failures
      [self]
    end
    
    def failure_chains
      [FailureChain.new(self)]
    end
  end
end