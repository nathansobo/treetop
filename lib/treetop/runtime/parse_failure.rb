module Treetop
  module Runtime
    class ParseFailure < ParseResult
      def index
        interval.first
      end

      def resume_index
        interval.first
      end
    end
  end
end
