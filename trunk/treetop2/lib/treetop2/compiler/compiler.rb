module Treetop2
  module Compiler
    class TerminalExpression < ::Treetop::SequenceSyntaxNode
      def compile(lexical_address)
        "#{lexical_address} = parse_terminal(#{text_value})"
      end
    end
    
    class AnythingSymbol < ::Treetop::TerminalSyntaxNode
      def compile(lexical_address)
        "#{lexical_address} = parse_anything"
      end
    end
  end
end