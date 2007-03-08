module Treetop
  class NonterminalParseFailure < ParseFailure
    attr_reader :nested_failures
    
    def initialize(index, parsing_expression, nested_failures)
      super(index, parsing_expression)
      @nested_failures = nested_failures
    end
  end
end