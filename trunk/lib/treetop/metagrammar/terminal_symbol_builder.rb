module Treetop
 class TerminalSymbolBuilder < ParsingExpressionBuilder
    module TerminalStringSyntaxNode
      def prefix
        elements[1].text_value
      end
      
      def value(grammar = nil)
        TerminalSymbol.new(prefix)
      end
    end
    
    def build
      choice(single_quoted_string, double_quoted_string, :character_class, :anything_symbol)
    end
    
    def double_quoted_string
      seq('"', zero_or_more(double_quoted_string_char), '"') do
        include TerminalStringSyntaxNode
      end
    end
    
    def double_quoted_string_char
      seq(notp('"'), choice(escaped('"'), any))
    end
    
    def single_quoted_string
      seq("'", zero_or_more(single_quoted_string_char), "'") do
        include TerminalStringSyntaxNode
      end
    end
    
    def single_quoted_string_char
      seq(notp("'"), choice(escaped("'"), any))
    end
  end
end