module Treetop
  module Compiler    
    class Nonterminal < AtomicExpression
      def compile(address, builder, parent_expression = nil)
        super
        use_vars :result
        assign_result text_value == 'super' ? 'super' : "_nt_#{text_value}"
        extend_result inline_module_name if inline_module_name
      end
    end
  end
end