module Treetop2
  module Parser
    class CompiledParser
      protected
      attr_writer :index
    
      public        
      attr_reader :input, :index

      def parse(input)
        prepare_to_parse(input)
        return root
      end
        
      def prepare_to_parse(input)
        @input = input
        @index = 0
      end
 
      def parse_char_class(char_class_re, char_class_string, node_class = SyntaxNode, inline_module = nil)
        if input.index(char_class_re, index) == index
          result = node_class.new(input, index...(index + 1))
          result.extend(inline_module) if inline_module
          @index += 1
          result
        else
          terminal_parse_failure("[#{char_class_string}]")
        end
      end
    
      def parse_terminal(terminal_string, node_class = SyntaxNode, inline_module = nil)
        if input.index(terminal_string, index) == index
          result = node_class.new(input, index...(index + terminal_string.length))
          result.extend(inline_module) if inline_module
          @index += terminal_string.length
          result
        else
          terminal_parse_failure(terminal_string)
        end
      end
    
      def parse_anything(node_class = SyntaxNode, inline_module = nil)
        if index < input.length
          result = node_class.new(input, index...(index + 1))
          result.extend(inline_module) if inline_module
          @index += 1
          result
        else
          terminal_parse_failure("any character")
        end
      end
    
      def terminal_parse_failure(expected_string)
        TerminalParseFailure.new(index, expected_string)
      end
    end
  end
end