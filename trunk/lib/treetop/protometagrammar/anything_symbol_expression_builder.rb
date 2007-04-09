module Treetop
  class Protometagrammar
    class AnythingSymbolExpressionBuilder < ParsingExpressionBuilder
      def build
        exp(".") do
          def value(grammar = nil)
            AnythingSymbol.new
          end
        end
      end
    end
  end
end