module Treetop
  module Runtime
    class Propagation < ParseResult
      attr_reader :element
      
      def initialize(element)
        super(element.interval)
        @element = element
        @dependencies = [element]
      end

      def resume_index
        element.resume_index
      end
      
      def inspect
        "Propagation(#{element.inspect})"
      end
    end
  end
end