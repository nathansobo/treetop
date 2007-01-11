module Treetop
  class Sequence < CompositeParsingExpression
    attr_reader :elements, :node_class
    
    def initialize(elements)
      @node_class = Class.new(SequenceSyntaxNode)
      @elements = elements
    end
    
    def node_class_eval(&block)
      node_class.class_eval &block
    end
    
    def parse_at(input, start_index, parser)
      results = []
      next_index = start_index
      
      for elt in elements
        result = elt.parse_at(input, next_index, parser)
        if result.is_a? ParseFailure
          return ParseFailure.new(start_index)
        else
          results << result
          next_index = result.interval.end
        end
      end
      
      interval = start_index...next_index
      return node_class.new(input, interval, results)
    end
  end
end