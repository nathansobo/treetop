module Treetop
  module Runtime
    class ParseResult
      attr_reader :dependent_results, :storages
      attr_accessor :interval, :parent
      
      def initialize(interval)
        @interval = interval
        @dependent_results = []
        @storages = []
      end
    end
  end
end
