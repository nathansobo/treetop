module Treetop2
  class NodeCache
    attr_reader :parse_results
    
    def initialize
      @parse_results = {}
    end
  
    def empty?
      parse_results.empty?
    end
  
    def store(parse_result)
      if parse_result.failure?
        parse_results[parse_result.index] = parse_result
      else
        parse_results[parse_result.interval.begin] = parse_result
      end
    end
  
    def [](start_index)
      parse_results[start_index]
    end
  end
end