module Treetop
  module Compiler    
    class CharacterClass < AtomicExpression
      def compile(address, builder, parent_expression = nil)
        super
        assign_result "parse_char_class(/#{text_value}/, '#{elements[1].text_value.gsub(/'$/, "\\\\'")}', #{node_class_name}#{optional_arg(inline_module_name)})"
      end
    end
  end
end