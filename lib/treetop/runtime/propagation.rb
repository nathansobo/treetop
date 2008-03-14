module Treetop
  module Runtime
    class Propagation < ParseResult
      attr_reader :element, :interval

      def initialize(element)
        interval = element.epsilon? ? (element.interval.first..element.interval.last) : element.interval
        super(interval)
        @element = element
        @dependencies = [element]
      end

      def resume_index
        element.resume_index
      end

      def epsilon?
        element.epsilon?
      end
      
      def inspect
        "Propagation(#{element.inspect})"
      end
    end
  end
end