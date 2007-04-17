module Treetop
  class SyntaxNode
    attr_reader :input, :interval, :nested_failures
    
    def initialize(input, interval, nested_failures = [])
      @input = input
      @interval = interval
      @nested_failures = nested_failures
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