module Treetop2
  module Compiler
    class TerminalExpression < SequenceSyntaxNode
      def proc_body
        'foo'
      end
    end
  end
end