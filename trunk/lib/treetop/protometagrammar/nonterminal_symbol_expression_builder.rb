module Treetop
  class Protometagrammar
    class NonterminalSymbolExpressionBuilder < ParsingExpressionBuilder
      def build
        seq(notp(:keyword), nonterminal_symbol) do
          def value(grammar)
            nonterminal_symbol.value(grammar)
          end
        
          def nonterminal_symbol
            elements[1]
          end
        end
      end

      def nonterminal_symbol
        seq(alpha_char, zero_or_more(alphanumeric_char)) do
          def value(grammar)
            grammar.nonterminal_symbol(name)
          end

          def name
            text_value.to_sym
          end
        end
      end

      def alpha_char
        char_class('A-Za-z')
      end

      def numeric_char
        char_class('0-9')
      end

      def alphanumeric_char
        choice(alpha_char, numeric_char)
      end
    end
  end
end