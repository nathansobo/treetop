module Treetop
  class SyntaxNode
    attr_reader :input, :interval, :embedded_failure
    
    def initialize(input, interval, embedded_failure = nil)
      @input = input
      @interval = interval
      @embedded_failure = embedded_failure
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
  end
end