module Treetop
  module Compiler
    class AtomicExpression < ParsingExpression
      def inline_modules
        []
      end
      
      def single_quote(string)
        "'#{string.gsub(/'$/, "\\'")}'"
      end
    end
  end
end