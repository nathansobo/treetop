module Treetop
  module Compiler
    class DeclarationSequence < Runtime::SyntaxNode

      def compile(builder)
        unless rules.empty?
          builder.method_declaration("root") do
            builder.assign 'result', rules.first.method_name
            builder.if__ 'index == input.size' do
              builder << 'return result'
            end
            builder.else_ do
              builder << 'return ParseFailure.new(input, index, result.nested_failures)'
            end
          end
          builder.newline
        end
        
        declarations.each do |declaration|
          declaration.compile(builder)
          builder.newline
        end
      end
      
      def rules
        declarations.select { |declaration| declaration.instance_of?(ParsingRule) }
      end
    end
  end
end