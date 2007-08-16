module Treetop2
  module Parser
    class ParseFailure < ParseResult
      attr_reader :index
    
      def initialize(index, nested_results = [])
        super(nested_results)
        @index = index
      end
    
      def success?
        false
      end
    
      def failure?
        true
      end
    
      def interval      
        @interval ||= (index...index)
      end    
    end
  end
end