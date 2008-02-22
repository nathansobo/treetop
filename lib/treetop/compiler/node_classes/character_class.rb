module Treetop
  module Compiler    
    class CharacterClass < AtomicExpression
      def compile(address, builder, parent_expression = nil)
        super
        
        builder.if__ "input.index(Regexp.new(#{single_quote(text_value)}), index) == index" do
          assign_result "(#{node_class_name}).new(input, index...(index + 1))"
          extend_result_with_inline_module
          builder << "@index += 1"
        end
        builder.else_ do
          assign_result "terminal_parse_failure(#{single_quote(characters)}, 1)"
        end
      end
    end
  end
end
