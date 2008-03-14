module Treetop
  module Compiler
    class Choice < ParsingExpression
      def compile(address, builder, parent_expression = nil)
        super
        begin_comment(self)
        use_vars :result, :start_index
        builder.assign "failed_alternatives", "[]"
        compile_alternatives(alternatives)
        builder << "#{result_var}.dependencies.concat(failed_alternatives)"
        end_comment(self)
      end
      
      def compile_alternatives(alternatives)
        obtain_new_subexpression_address
        alternatives.first.compile(subexpression_address, builder)
        builder.if__ subexpression_success? do
          assign_result subexpression_result_var
          extend_result_with_declared_module
          extend_result_with_inline_module
          assign_result "Propagation.new(#{result_var})"
        end
        builder.else_ do
          builder.accumulate "failed_alternatives", subexpression_result_var          
          if alternatives.size == 1
            reset_index
            assign_failure start_index_var, subexpression_result_var
          else
            compile_alternatives(alternatives[1..-1])
          end
        end
      end
    end
  end
end