module Treetop
  class ParseFailure
    attr_reader :index
    
    def initialize(index)
      @index = index
    end
  end
end