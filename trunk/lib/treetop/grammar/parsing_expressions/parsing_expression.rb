module Treetop
  class ParsingExpression
    def node_cache(parser)
      parser.node_cache_for(self)
    end
    
    def parse_at(input, start_index, parser)
      node_cache = node_cache(parser)
      node_cache[start_index] || node_cache.store(parse_at_without_caching(input, start_index, parser))
    end

    def failure_at(index, nested_failures)
      NonterminalParseFailure.new(index, self, nested_failures)
    end
    
    def zero_or_more
      ZeroOrMore.new(self)
    end
    
    def one_or_more
      OneOrMore.new(self)
    end
    
    def optional
      Optional.new(self)
    end
    
    def and_predicate
      AndPredicate.new(self)
    end
    
    def not_predicate
      NotPredicate.new(self)
    end
    
    def parenthesize(string)
      "(#{string})"
    end
  end
  
  class NodeInstantiatingParsingExpression < ParsingExpression
    attr_reader :node_class
    
    def initialize
      @node_class = Class.new(node_superclass)
    end
    
    def node_class_eval(&block)
      node_class.class_eval &block
    end
  end
  
  class NodePropagatingParsingExpression < ParsingExpression
  end
end