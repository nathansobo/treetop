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
    
    protected
    def failure_at(index, nested_results = [])
      ParseFailure.new(index, collect_nested_failures(nested_results))
    end
    
    def collect_nested_failures(results)
      (results.collect {|result| result.nested_failures}).flatten
    end
  end
end