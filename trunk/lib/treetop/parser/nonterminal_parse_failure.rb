module Treetop
  class NonterminalParseFailure < ParseFailure
    attr_reader :nested_failures
    
    def initialize(index, parsing_expression, nested_failures)
      super(index, parsing_expression)
      @nested_failures = nested_failures
    end
    
    def nested_failure_chains
      nested_failures.collect(&:failure_chains).flatten.sort_by(&:terminal_index).reverse
    end
    
    def failure_chains
      nested_failure_chains.collect { |failure_chain| failure_chain.add(self)  }
    end
  end
end