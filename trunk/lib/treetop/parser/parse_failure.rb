module Treetop
  class ParseFailure < ParseResult
    attr_reader :index
    
    def initialize(index, nested_failures = [])
      super(nested_failures)
      @index = index
    end
    
    def success?
      false
    end
    
    def failure?
      true
    end
    
    def interval      
      @interval ||= (index...index)
    end    
  end
end