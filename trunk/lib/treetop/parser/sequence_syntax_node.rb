module Treetop
  class SequenceSyntaxNode < SyntaxNode
    attr_reader :elements
    
    def initialize(input, consumed_interval, elements)
      super(input, consumed_interval)
      @elements = elements
    end
    
    def empty?
      elements.empty?
    end
  end
end