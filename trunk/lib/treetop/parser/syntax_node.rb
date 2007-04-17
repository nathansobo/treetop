module Treetop
  class SyntaxNode
    attr_reader :input, :interval
    
    def initialize(input, interval)
      @input = input
      @interval = interval
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