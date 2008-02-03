module Treetop
  module Compiler    
    class AnythingSymbol < AtomicExpression
      def compile(address, builder, parent_expression = nil)
        super
        builder.if__ "index < input_length" do
          assign_result "(#{node_class_name}).new(input, index...(index + 1))"
          extend_result_with_inline_module
          builder << "@index += 1"
        end
        builder.else_ do
          assign_result 'terminal_parse_failure("any character", 1)'
        end
      end
    end
  end
end