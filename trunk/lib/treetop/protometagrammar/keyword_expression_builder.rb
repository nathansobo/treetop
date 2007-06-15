module Treetop
  class Protometagrammar
    class KeywordExpressionBuilder < ParsingExpressionBuilder
      def build
        seq(choice('rule', 'end'), notp(non_space_character))
      end
      
      def non_space_character
        seq(notp(exp(:space)), any)
      end
    end
  end
end
