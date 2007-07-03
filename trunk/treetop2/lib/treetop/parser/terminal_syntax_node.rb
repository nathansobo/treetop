module Treetop
  class TerminalSyntaxNode < SyntaxNode

    def initialize(input, interval)
      super(input, interval, [])
    end

    def epsilon?
      text_value.eql? ""
    end
  end
end