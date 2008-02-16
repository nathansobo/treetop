module Treetop
  module Runtime
    class ParseResult
      attr_reader :dependent_results
      attr_accessor :interval, :parent
      
      def initialize(interval)
        @interval = interval
        @dependent_results = []
      end
    end
  end
end
