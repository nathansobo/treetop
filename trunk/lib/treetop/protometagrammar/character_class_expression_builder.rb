module Treetop
  class Protometagrammar
    class CharacterClassExpressionBuilder < ParsingExpressionBuilder
      def build
        character_class
      end
  
      def character_class
        seq('[', zero_or_more(char_class_char), ']')  do
          def value(grammar = nil)
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