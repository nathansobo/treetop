module Treetop
  class Metagrammar < Grammar
    def initialize
      super
      build do
        rule :nonterminal_symbol, NonterminalSymbolBuilder.new  
        rule :terminal_symbol, TerminalSymbolBuilder.new
        rule :character_class, CharacterClassBuilder.new
      end
    end
    
    class NonterminalSymbolBuilder
      def build
        nonterminal_symbol 
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
    
    class TerminalSymbolBuilder
      module TerminalSymbolSyntaxNode
        def prefix
          elements[1].text_value
        end
        
        def value(grammar=nil)
          TerminalSymbol.new(prefix)
        end
      end
      
      def build
        choice(single_quoted_string, double_quoted_string)
      end
      
      def double_quoted_string
        seq('"', zero_or_more(double_quoted_string_char), '"') do
          include TerminalSymbolSyntaxNode
        end
      end
      
      def double_quoted_string_char
        seq(notp('"'), choice(escaped('"'), any))
      end
      
      def single_quoted_string
        seq("'", zero_or_more(single_quoted_string_char), "'") do
          include TerminalSymbolSyntaxNode
        end
      end
      
      def single_quoted_string_char
        seq(notp("'"), choice(escaped("'"), any))
      end
    end

    class CharacterClassBuilder
      def build
        character_class
      end
      
      def character_class
        seq('[', zero_or_more(char_class_char), ']')  do
          def value
            CharacterClass.new(characters)
          end
          
          def characters
            elements[1].text_value
          end
        end
      end
      
      def char_class_char
        seq(notp(']'), choice(escaped(']'), any))
      end
    end
  end
end
