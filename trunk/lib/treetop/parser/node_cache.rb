module Treetop
  class NodeCache
    attr_reader :parse_results
    
    def initialize
      @parse_results = {}
    end
  
    def empty?
      parse_results.empty?
    end
  
    def store(parse_result)
      parse_results[parse_result.consumed_interval.begin] = parse_result
    end
  
    def [](start_index)
      parse_results[start_index]
    end
  end
end