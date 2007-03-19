module Treetop
  class NodeCache
    attr_reader :nodes
    
    def initialize
      @nodes = {}
    end
  
    def empty?
      nodes.empty?
    end
  
    def store(syntax_node)
      nodes[syntax_node.interval.begin] = syntax_node
    end
  
    def [](start_index)
      nodes[start_index]
    end
  end
end