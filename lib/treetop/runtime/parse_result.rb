module Treetop
  module Runtime
    class ParseResult
      attr_reader :interval
      attr_accessor :parent, :source_rule_name
      
      def initialize(interval)
        @interval = interval
      end
    end
  end
end
