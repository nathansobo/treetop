module Treetop
  module Runtime
    class ParseResult
      attr_reader :input
    
      def initialize(input)
        @input = input
      end
    end
  end
end