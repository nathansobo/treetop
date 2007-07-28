module Treetop2
  class SequenceSyntaxNode < SyntaxNode
    attr_reader :elements
    
    def initialize(input, interval, elements, nested_results=elements)
      super(input, interval, elements)
      @elements = elements
    end
    
    def empty?
      elements.empty?
    end
  end
end