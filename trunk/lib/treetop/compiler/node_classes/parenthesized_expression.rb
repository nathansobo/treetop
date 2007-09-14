module Treetop
  module Compiler    
    class ParenthesizedExpression < Runtime::SyntaxNode
      def compile(address, builder, parent_expression = nil)
        elements[2].compile(address, builder)
      end
    end
  end
end