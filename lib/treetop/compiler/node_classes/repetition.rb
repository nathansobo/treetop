module Treetop
  module Compiler
    class Repetition < ParsingExpression
      def compile(address, builder, parent_expression)
        super
        repeated_expression = parent_expression.atomic
        begin_comment(parent_expression)
        use_vars :result, :accumulator, :start_index

        obtain_new_subexpression_address
        builder.assign subexpression_result_var, 'nil'
        builder.loop do
          repeated_expression.compile(subexpression_address, builder)
          builder.if__ subexpression_success? do
            accumulate_subexpression_result
          end
          builder.else_ do
            builder.break
          end
        end
      end
      
      def inline_module_name
        parent_expression.inline_module_name
      end
      
      def assign_and_extend_result
        assign_result "#{node_class_name}.new(input, #{start_index_var}...index, #{accumulator_var})"
        extend_result_with_inline_module
      end
    end

    class ZeroOrMore < Repetition
      def compile(address, builder, parent_expression)
        super
        assign_and_extend_result
        accumulate_dependency subexpression_result_var
        end_comment(parent_expression)
      end
    end
  
    class OneOrMore < Repetition
      def compile(address, builder, parent_expression)
        super
        builder.if__ "#{accumulator_var}.empty?" do
          reset_index
          assign_failure start_index_var, subexpression_result_var
        end
        builder.else_ do
          assign_and_extend_result
        end
        accumulate_dependency subexpression_result_var
        end_comment(parent_expression)
      end
    end
  end
end