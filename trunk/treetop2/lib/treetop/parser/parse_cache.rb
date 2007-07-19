module Treetop2
  class ParseCache
    attr_reader :node_caches
    
    def initialize
      @node_caches = {}
    end
    
    def [](parsing_expression)
      node_caches[parsing_expression] ||= NodeCache.new
    end
    
    def empty?
      node_caches.empty?
    end
  end
end