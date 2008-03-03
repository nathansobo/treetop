module Treetop
  module Runtime
    class Propagation < ParseResult
      attr_reader :element
      
      def initialize(element)
        super(element.interval)
        @element = element
      end
    end
  end
end