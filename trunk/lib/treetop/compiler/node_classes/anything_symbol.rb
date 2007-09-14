module Treetop
  module Compiler    
    class AnythingSymbol < Runtime::SyntaxNode
      include ParsingExpression
      include AtomicExpression
      
      def compile(address, builder, parent_expression = nil)
        super
        assign_result "parse_anything(#{node_class}#{optional_arg(inline_module_name)})"
      end
    end
  end
end
