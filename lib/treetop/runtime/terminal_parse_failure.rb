module Treetop
  module Runtime
    class TerminalParseFailure < ParseFailure
      attr_reader :expected_string

      def initialize(interval, expected_string)
        super(interval)
        @expected_string = expected_string
      end

      def to_s
        "String matching #{expected_string} expected."
      end

      def inspect
        "TerminalParseFailure(#{interval}, #{expected_string})"
      end
    end
  end
end
