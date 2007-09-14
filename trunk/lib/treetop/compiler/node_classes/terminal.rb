module Treetop
  module Compiler    
    class Terminal < ParsingExpression
      include AtomicExpression
      
      def compile(address, builder, parent_expression = nil)
        super
        assign_result "parse_terminal(#{text_value}, #{node_class}#{optional_arg(inline_module_name)})"
      end
    end
 end
end