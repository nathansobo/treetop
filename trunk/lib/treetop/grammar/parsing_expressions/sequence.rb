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
      node_cache = node_cache(parser)
      node_cache[start_index] || node_cache.store(parse_at_without_caching(input, start_index, parser))
    end
    
    def parse_at_without_caching(input, start_index, parser)
      results = []
      next_index = start_index
      
      for elt in elements
        result = elt.parse_at(input, next_index, parser)
        results << result
        return failure_at(start_index, collect_nested_failures(results)) if result.failure?
        next_index = result.interval.end
      end
    
      interval = start_index...next_index      
      node_class.new(input,
                     interval,
                     results,
                     collect_nested_failures(results))
    end
    
    def to_s
      parenthesize((@elements.collect {|elt| elt.to_s}).join(" "))
    end
    
    private
    def collect_nested_failures(results)
      results.collect do |result|
        result.nested_failures + (result.failure? ? [result] : [])
      end.flatten
    end
  end
end