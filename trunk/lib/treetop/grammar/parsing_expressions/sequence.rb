module Treetop
  class Sequence < NodeInstantiatingParsingExpression
    attr_reader :elements, :node_class
    
    def initialize(elements)
      super()
      @elements = elements
    end
    
    def node_superclass
      SequenceSyntaxNode
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