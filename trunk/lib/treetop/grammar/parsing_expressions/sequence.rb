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
        
    def to_s
      parenthesize((@elements.collect {|elt| elt.to_s}).join(" "))
    end

    protected
    def parse_at_without_caching(input, start_index, parser)
      results = []
      next_index = start_index
      
      for elt in elements
        result = elt.parse_at(input, next_index, parser)
        results << result
        return failure_at(start_index) if result.failure?
        next_index = result.interval.end
      end
    
      interval = start_index...next_index      
      node_class.new(input,
                     interval,
                     results)
    end    
  end
end