module Treetop
  module Compiler
    class Choice < ParsingExpression
      def compile(address, builder, parent_expression = nil)
        super
        begin_comment(self)
        use_vars :result, :start_index, :nested_results
        compile_alternatives(alternatives)
        end_comment(self)
      end
      
      def compile_alternatives(alternatives)
        obtain_new_subexpression_address
        alternatives.first.compile(subexpression_address, builder)
        accumulate_nested_result
        builder.if__ subexpression_success? do
          assign_result subexpression_result_var
          builder << "#{subexpression_result_var}.update_nested_results(#{nested_results_var})"
        end
        builder.else_ do
          if alternatives.size == 1
            reset_index
            assign_failure start_index_var, nested_results_var
          else
            compile_alternatives(alternatives[1..-1])
          end
        end
      end
    end
  end
end