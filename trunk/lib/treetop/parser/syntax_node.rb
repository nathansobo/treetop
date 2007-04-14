module Treetop
  class SyntaxNode
    attr_reader :input, :consumed_interval
    
    def initialize(input, consumed_interval)
      @input = input
      @consumed_interval = consumed_interval
    end
    
    def text_value
      input[consumed_interval]
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