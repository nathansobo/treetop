module Treetop
  module Compiler    
    class AnythingSymbol < AtomicExpression
      def compile(address, builder, parent_expression = nil)
        super
        builder.if__ "index < input_length" do
          builder << 'next_character = index + input[index..-1].match(/\A(.)/um).end(1)'
          assign_result "instantiate_node(#{node_class_name},input, index...next_character)"
          extend_result_with_inline_module
          builder << "@index = next_character"
        end
        builder.else_ do
          builder << 'terminal_parse_failure("any character")'
          assign_result 'nil'
        end
      end
    end
  end
end