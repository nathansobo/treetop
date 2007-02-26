module Treetop
  class ExpectationDescriptor
    attr_reader :expression
    
    def initialize(expression)
      @expression = expression
    end
  end
end