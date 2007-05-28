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
      ParseFailure.new(index, collect_nested_failures_at_maximum_index(nested_results))
    end
        
    def collect_nested_failures_at_maximum_index(results)
      maximum_index = 0
      nested_failures = []
      
      results.each do |result|
        next if result.nested_failures.empty?
        index_of_nested_failures = result.nested_failures.first.index
        if index_of_nested_failures > maximum_index
          maximum_index = index_of_nested_failures
          nested_failures = result.nested_failures
        elsif index_of_nested_failures == maximum_index
          nested_failures += result.nested_failures
        end
      end
      
      return nested_failures
    end
    
  end
end