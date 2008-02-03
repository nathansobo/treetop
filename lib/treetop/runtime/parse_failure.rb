module Treetop
  module Runtime
    class ParseFailure
      attr_reader :interval
      attr_accessor :parent

      def initialize(interval)
        @interval = interval
      end

      def index
        interval.first
      end

      def resume_index
        interval.first
      end
    end
  end
end
