module Treetop
  class TerminalParseFailure < ParseFailure
    attr_reader :expected_string

    def initialize(index, expected_string)
      super(index)
      @expected_string = expected_string      
    end

    def nested_failures
      [self]
    end
    
    def to_s
      "String matching #{expected_string} expected at position #{index}."
    end
  end
end