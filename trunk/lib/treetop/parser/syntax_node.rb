module Treetop
  class SyntaxNode < ParseResult
    attr_reader :input, :interval
    
    def initialize(input, interval, nested_failures = [])
      super(nested_failures)
      @input = input
      @interval = interval
    end
    
    def update_nested_failures(failures)      
      @nested_failures = select_failures_at_maximum_index(nested_failures + failures)
    end
        
    def text_value
      input[interval]
    end
    
    def success?
      true
    end
    
    def failure?
      false
    end
    
    def epsilon?
      false
    end
  end
end