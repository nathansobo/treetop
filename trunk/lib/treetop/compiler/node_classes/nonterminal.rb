module Treetop
  module Compiler    
    class Nonterminal < ParsingExpression
      include AtomicExpression
      
      def compile(address, builder, parent_expression = nil)
        super
        use_vars :result
        assign_result text_value == 'super' ? 'super' : "_nt_#{text_value}"
      end
    end
  end
end