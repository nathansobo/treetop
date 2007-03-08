module Treetop
  class SequenceSyntaxNode < SyntaxNode
    attr_reader :elements, :nested_failures
    
    def initialize(input, interval, elements, nested_failures)
      super(input, interval)
      @elements = elements
      @nested_failures = nested_failures
    end
    
    def empty?
      elements.empty?
    end
  end
end