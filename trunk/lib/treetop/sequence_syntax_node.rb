module Treetop
  class SequenceSyntaxNode < SyntaxNode
    attr_reader :elements
    
    def initialize(input, interval, elements)
      super(input, interval)
      @elements = elements
    end
  end
end