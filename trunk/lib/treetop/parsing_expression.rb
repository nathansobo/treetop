module Treetop
  class ParsingExpression
    def zero_or_more
      ZeroOrMore.new(self)
    end
    
    def one_or_more
      OneOrMore.new(self)
    end
    
    def optional
      Optional.new(self)
    end
  end
  
  class AtomicParsingExpression < ParsingExpression
  end
  
  class CompositeParsingExpression < ParsingExpression
  end
end