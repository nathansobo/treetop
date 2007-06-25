module Treetop
  class SequenceSyntaxNode < SyntaxNode
    attr_reader :elements, :expression
    
    def initialize(expression, input, interval, elements, nested_failures = [])
      super(input, interval, nested_failures)
      @expression = expression
      @elements = elements
    end
    
    def empty?
      elements.empty?
    end
  end
end