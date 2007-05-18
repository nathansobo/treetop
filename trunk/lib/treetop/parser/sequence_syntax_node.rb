module Treetop
  class SequenceSyntaxNode < SyntaxNode
    attr_reader :elements
    
    def initialize(input, interval, elements, nested_failures = [])
      super(input, interval, nested_failures)
      @elements = elements
    end
    
    def empty?
      elements.empty?
    end
  end
end