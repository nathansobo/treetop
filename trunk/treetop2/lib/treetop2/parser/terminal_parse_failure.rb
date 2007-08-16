module Treetop2
  module Parser
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
    
      def ==(other_failure)
        eql?(other_failure)
      end
    
      def eql?(other_failure)
        return false unless other_failure.instance_of?(TerminalParseFailure)
        expected_string.eql?(other_failure.expected_string) && index.eql?(other_failure.index)
      end
    
      def hash
        [index, expected_string].hash
      end
    end
  end
end