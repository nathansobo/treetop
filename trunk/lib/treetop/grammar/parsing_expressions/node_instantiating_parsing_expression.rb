module Treetop
  class NodeInstantiatingParsingExpression < ParsingExpression
    attr_reader :node_class
    
    def initialize(node_class = nil, &block)
      @node_class = node_class || Class.new(node_superclass)
      node_class_eval(&block) if block_given?
    end
    
    def node_class_eval(string = nil, &block)      
      node_class.class_eval(string) if string
      node_class.class_eval(&block) if block
    end    
  end
end