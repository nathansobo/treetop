module Treetop
  class NodeInstantiatingParsingExpression < ParsingExpression
    
    def initialize(&block)
      node_class_eval(&block) if block_given?
    end
    
    def with_node_class(a_class, &block)
      self.node_class = a_class
      node_class_eval(&block) if block_given?
      return self
    end
    
    def node_class_eval(string = nil, &block)      
      node_class.class_eval(string) if string
      node_class.class_eval(&block) if block
    end
    
    def node_class
      self.node_class = Class.new(node_superclass) if @node_class.nil?
      @node_class
    end
    
    protected
    
    def node_class=(a_class)
      @node_class = a_class
      after_node_class_assignment
    end
    
    def after_node_class_assignment
    end
    
  end
end