module Treetop
  class ParseFailure
    attr_reader :index, :expression
    
    def initialize(index, expression = nil)
      @index = index
      @expression = expression
    end
    
    def success?
      false
    end
    
    def failure?
      true
    end
    
    def interval
      index...index
    end
  end
end