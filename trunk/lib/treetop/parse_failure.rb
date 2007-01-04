module Treetop
  class ParseFailure
    attr_reader :index
    
    def initialize(index)
      @index = index
    end
    
    def success?
      false
    end
    
    def failure?
      true
    end
  end
end