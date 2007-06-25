module Treetop
  class SequenceSyntaxNode < SyntaxNode
    attr_reader :elements
    
    def initialize(expression, input, interval, elements, nested_failures = [])
      super(expression, input, interval, nested_failures)
      @elements = elements
    end
    
    def empty?
      elements.empty?
    end
  end
end