module Treetop
  module Compiler    
    class CharacterClass < Runtime::SyntaxNode
      include ParsingExpression
      include AtomicExpression
      
      def compile(address, builder, parent_expression = nil)
        super
        assign_result "parse_char_class(/#{text_value}/, '#{elements[1].text_value.gsub(/'$/, "\\\\'")}', #{node_class}#{optional_arg(inline_module_name)})"
      end
    end
  end
end