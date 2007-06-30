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
    
    def and_predicate
      AndPredicate.new(self)
    end
    
    def not_predicate
      NotPredicate.new(self)
    end
    
    def parenthesize(string)
      "(#{string})"
    end
    
    def label
      nil
    end
    
    protected
    def failure_at(index, nested_results)
      ParseFailure.new(index, nested_results)
    end    
  end
end