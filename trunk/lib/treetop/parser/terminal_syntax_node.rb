module Treetop
  class TerminalSyntaxNode < SyntaxNode
    attr_accessor :nested_failures
    
    def initialize(*args)
      super
      self.nested_failures = []
    end
    
    def epsilon?
      text_value.eql? ""
    end
  end
end