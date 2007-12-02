module Treetop
  module Compiler
    class AtomicExpression < ParsingExpression
      def inline_modules
        []
      end
    end
  end
end