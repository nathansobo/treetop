module Treetop
  module Runtime
    class CompiledParser
      include Treetop::Runtime
      
      attr_accessor :consume_all_input
      attr_writer :root
      alias :consume_all_input? :consume_all_input
      attr_reader :input, :index, :terminal_failures, :max_terminal_failure_index

      def initialize
        self.consume_all_input = true
      end

      def parse(input, options = {})
        prepare_to_parse(input)
        @index = options[:index] if options[:index]
        result = send("_nt_#{root}")
        return nil if (consume_all_input? && index != input.size)
        return result
      end
      
      protected
      
      attr_reader :node_cache
      attr_writer :index
              
      def prepare_to_parse(input)
        @input = input
        reset_index
        @node_cache = Hash.new {|hash, key| hash[key] = Hash.new}
        @terminal_failures = []
        @max_terminal_failure_index = 0
      end
      
      def reset_index
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
        return nil if index < max_terminal_failure_index
        if index > max_terminal_failure_index
          @max_terminal_failure_index = index
          @terminal_failures = []
        end
        terminal_failures << TerminalParseFailure.new(index, expected_string)
        return nil
      end
    end
  end
end