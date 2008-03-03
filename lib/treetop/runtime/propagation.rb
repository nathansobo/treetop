module Treetop
  module Runtime
    class Propagation < ParseResult
      attr_reader :element
      
      def initialize(element)
        super(element.interval)
        @element = element
        @dependencies = [element]
      end
    end
  end
end