module Treetop
  class NodeInstantiatingParsingExpression < ParsingExpression
    
    def initialize(&block)
      node_class_eval(&block) if block_given?
    end
    
    def with_node_class(a_class, &block)
      @node_class = a_class
      node_class_eval(&block) if block_given?
      return self
    end
    
    def node_class_eval(string = nil, &block)      
      node_class.class_eval(string) if string
      node_class.class_eval(&block) if block
    end
    
    def node_class
      @node_class ||= Class.new(node_superclass)
      @node_class
    end
  end
end