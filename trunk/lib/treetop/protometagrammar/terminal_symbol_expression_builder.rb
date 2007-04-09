module Treetop
 class TerminalSymbolExpressionBuilder < ParsingExpressionBuilder
    module TerminalStringSyntaxNode
      def prefix
        elements[1].text_value
      end
      
      def value
        TerminalSymbol.new(prefix)
      end
    end
    
    def build
      seq(choice(single_quoted_string, double_quoted_string, :character_class, :anything_symbol),
          :trailing_block) do
        def value(grammar = nil)
          trailing_block.value(terminal.value)
        end
        
        def terminal
          elements[0]
        end
        
        def trailing_block
          elements[1]
        end
      end
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