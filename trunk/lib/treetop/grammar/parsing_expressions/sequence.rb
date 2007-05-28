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

    def parse_at(input, start_index, parser)
      results = []
      next_index = start_index
      
      for elt in elements
        result = elt.parse_at(input, next_index, parser)
        results << result
        return failure_at(start_index, results) if result.failure?
        next_index = result.interval.end
      end
      
      success(input, start_index...next_index, results, results)
    end
    
    protected

    def success(input, interval, results, encountered_child_results)
      return node_class.new(input,
                            interval,
                            results,
                            collect_nested_failures_at_maximum_index(encountered_child_results))
    end
  end
end