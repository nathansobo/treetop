module Treetop
  module Runtime
    class ParseFailure
      attr_reader :index
      attr_accessor :parent

      def initialize(index)
        @index = index
      end

      def interval
        index..index
      end
    end
  end
end
